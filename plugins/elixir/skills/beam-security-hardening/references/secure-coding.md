# BEAM Secure Coding Reference

Source: Erlang Ecosystem Foundation Security Working Group, "Secure Coding and Deployment Hardening Guidelines" (security.erlef.org). Examples in Erlang and Elixir; most points apply to all BEAM languages.

Secure coding reduces vulnerabilities but does not replace the rest of a Secure SDLC: threat modelling, static analysis (Sobelow, Credo), dynamic scanning, pen testing, and dependency vulnerability tracking.

---

## 1. Preventing atom exhaustion

**The risk:** Each unique atom takes a permanent slot in the global atom table. Entries are never removed (atoms are never garbage collected). Table size is fixed at startup via the `+t` emulator flag (default 1,048,576). Adding a value when the table is full **crashes the whole VM** — a denial-of-service. Creating atoms from untrusted input is the classic trigger. Over one third of CVEs published by the EEF CNA are atom-exhaustion bugs.

**Best fix: never create atoms at runtime.** If every atom the app needs is referenced in code, it is in the table when the code loads (at release startup). Then constrain conversions to existing values.

**Prefer lookup tables over `*_to_existing_atom`.** A lookup table (`%{"dark" => :dark, ...}`) is strictly safer because the `*_to_existing_atom/1` variants still accept arbitrary input and can resolve to an *unintended* existing atom (e.g. a module name, `:true`, `:erase`). A lookup table controls exactly which atoms are allowed.

Elixir:
- `String.to_existing_atom/1` not `String.to_atom/1`
- `List.to_existing_atom/1` not `List.to_atom/1`
- `Module.safe_concat/1,2` not `Module.concat/1,2`
- Never build atoms by interpolation: `:"new_atom_#{i}"`, `:'new_atom_#{i}'`, `~w[row_#{i}]a`
- `:erlang.binary_to_term(bin, [:safe])` on untrusted input

Erlang:
- `list_to_existing_atom/1` not `list_to_atom/1`
- `binary_to_existing_atom/1,2` not `binary_to_atom/1,2`
- `binary_to_term/2` with the `safe` option on untrusted input
- Do not use `file:consult/1` or `file:path_consult/2` on untrusted input

**Watch library functions that mint atoms from input:** `xmerl_scan` (XML tag/attr names → atoms), `http_uri:parse/1` (URI scheme → atom). See xmerl and inets sections.

**Runtime monitoring:** Instrument `erlang:system_info(atom_count)` against `erlang:system_info(atom_limit)`. Alert when the count keeps rising after startup or crosses a threshold (e.g. 80%). Visible in Observer / Phoenix LiveDashboard.

---

## 2. Serialisation and deserialisation

**Choose safe formats.** In untrusted environments use a standard format (JSON, XML, Protobuf) instead of External Term Format (ETF). Use a parser that does not generate atoms (configure it to return strings/binaries, or enable schema validation).

**ETF deserialisation is dangerous even with `:safe`.** `:safe` only blocks creation of *new* atoms and new external function refs. It does **not** stop:
- deserialisation/invocation of **functions** referencing already-loaded modules → Remote Code Execution
- existing-atom injection (flip control flow on pattern matches)
- huge/compressed terms → memory-exhaustion DoS (`:safe` puts no size limit)

Rules:
- Erlang: pass `safe` to `binary_to_term/2`; never deserialise-and-invoke functions from untrusted input; do not `file:consult/1` untrusted input.
- Elixir: use `Plug.Crypto.non_executable_binary_to_term/1,2` (raises on unsafe/executable terms) **and still pass `:safe`** to also block atom creation.

**Implicit invocation in Elixir (the trap).** The Enumerable protocol is implemented for 2-arity functions, so `Enum.map(term, fun)` will *call* a deserialised anonymous function without you writing an explicit call. A UI-theme cookie stored as ETF and later `Enum.map`-ed is a real RCE (analogous to CVE-2017-1000053). `Range` also implements Enumerable: a term like `1..9999999999999999` causes CPU/memory blowup, and `non_executable_binary_to_term` does **not** stop this — you still need input validation of the decoded value.

**Best practice for cookies/tokens:** authenticate before decoding. Use signed/encrypted cookies (`put_resp_cookie(conn, ..., sign: true)` / `encrypt: true`, read via `fetch_cookies(conn, signed: [...])`) so tampered data is rejected before `binary_to_term` runs. Prefer JSON + explicit schema for structured data.

---

## 3. Spawning external executables

**The risk:** Building a shell command string from untrusted input enables command injection (arbitrary commands, data exfiltration).

**Erlang:** Use `open_port/2` with `{spawn_executable, FileName}` instead of `os:cmd/1,2` and instead of `{spawn, Command}`. Pass args as a list via `{args, Args}` — they go to the executable as-is, no shell, no env expansion. Note: requires the full path, so call `os:find_executable/1,2` first. I/O behaviour differs from `os:cmd`, so it is not a drop-in replacement.

**Elixir:** `System.cmd/2,3` already wraps `open_port/2` and passes args as a list; locates the executable via `:os.find_executable/1` unless given an absolute path.

**Both:** Never use a shell (`/bin/sh -c "..."`) as the executable with args as one string — that throws away the injection protection.

**Environment leakage:** The spawned process inherits the BEAM's environment, which may hold secrets (e.g. `DB_PASSWORD`). Clear/override sensitive vars:
```erlang
open_port({spawn_executable, "/usr/bin/env"}, [{env, [{"DB_PASSWORD", false}]}]).
```
```elixir
System.cmd("env", [], env: %{"DB_PASSWORD" => nil})
```

---

## 4. Protecting sensitive data

**Why it is hard on the BEAM:** Data is immutable, so you cannot overwrite a secret in memory after use (the trick used in mutable languages). Secrets leak via stack traces, log messages, introspection (`erlang`/`sys`/`dbg`/Observer), crash dumps, and OS core dumps.

**Wrap secrets in a zero-arity closure.** Arguments at the top of a stack trace may be printed in full; a closure shows as `#Fun<...>` instead. Closures are also hidden from Observer and crash dumps.
```erlang
WrappedSecret = fun() -> os:getenv("SECRET") end.
```
```elixir
wrapped_secret = fn -> System.get_env("SECRET") end
```

**Prune arguments from stack traces** when calling code that cannot accept a closure (e.g. `crypto`). Wrap in try/catch (Erlang) or rescue (Elixir) and replace the arg list with its arity before re-raising:
```elixir
def encrypt_with_secret(message, wrapped_secret) do
  SomeCryptoLib.encrypt(message, wrapped_secret.())
rescue
  e -> reraise e, prune_stacktrace(System.stacktrace())
end

defp prune_stacktrace([{mod, fun, [_ | _] = args, info} | rest]),
  do: [{mod, fun, length(args), info} | rest]
defp prune_stacktrace(stacktrace), do: stacktrace
```
`Plug.Crypto.prune_args_from_stacktrace/1` does this if the package is available.

**Customize introspection (Elixir):** Implement or `@derive` the `Inspect` protocol on structs to mask sensitive fields. Implement `format_status/2` for `GenServer`/`:gen_event`/`:gen_statem` to mask internal state shown by Observer.

**Private ETS tables:** Declare tables holding secrets as `:private` — unreadable by other processes/remote shells and invisible in Observer.

**Sensitive processes:** `:erlang.process_flag(:sensitive, true)` blocks introspection and tracing of the process, and keeps its message queue, dictionary, gen state, heap and stack out of crash dumps. Downside: hard to troubleshoot. Best pattern: do secret work in a short-lived sensitive process with minimal logic, rather than hiding large business logic.

---

## 5. Sandboxing untrusted code

**There is no in-VM sandbox.** Any code running in a BEAM instance has near-unlimited access to the VM and host, and the same access to every other node in a distributed cluster. You cannot isolate "untrusted" processes.

- Erlang: never use `file:script/1,2` or `file:eval/1,2` on untrusted input (or in production at all).
- Elixir: never use `Code.eval_file`, `Code.eval_string`, `Code.eval_quoted` on untrusted input (or in production at all).
- To let users customize behaviour, embed a dedicated runtime designed for sandboxing — **Lua** (built for this; Erlang/Elixir bindings exist).

---

## 6. Preventing timing attacks

Comparing secrets with `==` or pattern matching uses variable-time equality: it stops at the first differing byte. An attacker can statistically analyse response times to recover the secret byte-by-byte.

Use a constant-time comparison:
- `crypto:hash_equals/2` (OTP 25+)
- Elixir: `Plug.Crypto.secure_compare/2` (bundled with Phoenix)
- Older OTP: `pbkdf2` package `compare_secure/2`, or `plug_crypto`

Both require equal-length inputs (typically hash outputs), so they leak only length; compare fixed-size hashes if even length matters.
```elixir
case Plug.Crypto.secure_compare(conn.assigns[:token], token) do
  true -> :ok
  false -> :access_denied
end
```

---

## 7. Standard library: ssl (TLS)

**TLS clients — the big one:** the `ssl` default is `verify_none`, so clients **silently ignore the server certificate and are open to MITM**. Always set:
- `verify: :verify_peer`
- a CA trust store: `cacerts: :public_key.cacerts_get()` (OTP 25+ OS store) or `cacertfile:`; or add `castore`/`certifi` and keep them updated
- often `depth: 2` or `3` (default 1 is too low for public servers)
- `customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]` for wildcard certs (OTP 21+; older: `ssl_verify_fun` package)

```elixir
:ssl.connect(~c"example.net", 443,
  verify: :verify_peer,
  cacerts: :public_key.cacerts_get(),
  depth: 3,
  customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]
)
```

**Test negatively** against https://badssl.com — confirming the connection *fails* when it should matters more than interoperability tests.

**Revocation (not done by default):** a revoked-but-valid cert is accepted unless you set `crl_check: true` with `crl_cache`. Caveat: `ssl_crl_cache` does not actually cache, so every handshake triggers a fresh CRL lookup (perf/reliability hit) — high-throughput apps with revocation needs require a custom cache.

**TLS servers:**
- Customize protocol versions/cipher suites for the use case. Modern OTP already scores 'A' on SSL Labs without tuning; harden further to Mozilla "Intermediate" (TLS 1.2 + 1.3, AEAD GCM/ChaCha20-Poly1305 suites, curves secp256r1/secp384r1; X25519 implicit). Filter preferred ciphers through `ssl:filter_cipher_suites/2` to drop unsupported ones. Keep `honor_cipher_order: false` per Mozilla.
- `client_renegotiation: false` to stop client-initiated renegotiation being a DoS vector (TLS ≤1.2 only; 1.3 has no renegotiation). Very long-lived 1.2 connections sending huge volumes may need renegotiation to avoid nonce wrap — they will be terminated if disabled.
- Make versions/ciphers runtime config, not hardcoded, so they can change without a rebuild.

When using libraries built on `ssl`, verify they use secure defaults.

---

## 8. Standard library: inets (httpc)

- `httpc` inherits `ssl` defaults → MITM-vulnerable. Pass a secure `ssl` option block (verify_peer, cacerts, depth, customize_hostname_check) on every HTTPS request.
- Use `uri_string:parse/1` not `http_uri:parse/1` on untrusted URIs — the latter turns the scheme into an atom (atom exhaustion).
- Note `autoredirect` defaults to true: httpc follows redirects and may resend auth headers to another host. Prefer higher-level clients (`Req`/`Finch`/`Mint`) that verify by default.

```elixir
:httpc.request(:get, {~c"https://www.example.net/", []}, [
  ssl: [
    verify: :verify_peer,
    cacerts: :public_key.cacerts_get(),
    depth: 2,
    customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]
  ]
], [])
```

---

## 9. Standard library: crypto and public_key

- `crypto` is a thin API over OpenSSL primitives; easy to misuse and silently fail security requirements. Prefer a higher-level API: NaCl/libsodium via `enacl`, or `plug_crypto` for encrypt/decrypt and sign/verify (especially in Plug/Phoenix).
- For asymmetric-key operations use `public_key`'s higher-level functions: `public_key:sign/3,4` over `crypto:sign/4,5`; `public_key:verify/4,5` over `crypto:verify/5,6`.

---

## 10. Standard library: xmerl (XML)

- Do not use `xmerl_scan` on untrusted (or trusted-but-highly-dynamic) input — it returns tag/attribute names as atoms → atom exhaustion DoS.
- With `xmerl_sax_parser` on untrusted input, disable internal **and** external entity expansion: in the `EventFun` callback, raise on `internalEntityDecl` or `externalEntityDecl` events. Entity expansion enables XML-bomb DoS (billion laughs); external entities add XXE (info leakage / SSRF). Search "XXE attack" for background.
