---
name: beam-security-hardening
description: Hardens Elixir/Erlang/Phoenix code and deployments and answers Zero Trust architecture questions. Use when writing or reviewing code that parses untrusted input, deserializes terms, shells out, handles secrets, compares tokens, parses XML, or makes TLS connections; when adding LiveView routes, live_session, on_mount hooks, or authorization in mount/handle_event; when hardening releases, Erlang distribution, EPMD, or crash dumps; or when asked about the NSA Zero Trust Implementation Guidelines (ZIG), pillars, capabilities, activities, or technology mappings.
---

# BEAM Security Hardening & Zero Trust

Two knowledge bases:
- **Part A** - BEAM secure coding + deployment hardening (EEF Security WG, security.erlef.org). Code-level, directly actionable.
- **Part B** - NSA Zero Trust Implementation Guidelines (ZIG). Published Jan 2026, **after model training cutoffs**.

**Never** answer BEAM security or Zero Trust questions from memory - the references override intuition, and the ZIG postdates training.

## Part A - Secure coding quick reference

Full detail per topic: [secure-coding.md](references/secure-coding.md)

### Atom exhaustion (DoS - a third of EEF-issued CVEs)
- **Never** `String.to_atom/1` on input, atom interpolation (`:"x_#{i}"`, `~w[x_#{i}]a`), `Module.concat` on input, `binary_to_atom`
- **Prefer** lookup tables (`%{"dark" => :dark}`) over `String.to_existing_atom/1` - existing-atom variants still accept unintended atoms
- **Monitor** `:erlang.system_info(:atom_count)` vs `:erlang.system_info(:atom_limit)`; alert on growth after startup

### ETF deserialization (RCE)
- **Never** trust `:erlang.binary_to_term(x, [:safe])` - `:safe` does not block function deserialization, existing-atom injection, or huge-term DoS
- **Use** `Plug.Crypto.non_executable_binary_to_term(x, [:safe])` + validate the decoded shape
- **Never** enumerate untrusted decoded terms - Enumerable runs 2-arity funs (implicit RCE); `Range` structs blow CPU/memory
- **Authenticate** cookies before decoding: `put_resp_cookie(conn, ..., sign: true)` / `encrypt: true`
- **Prefer** JSON with explicit schema over ETF

### Command injection
- **Never** `os:cmd/1` or a shell (`/bin/sh -c`) with one argument string
- **Use** `System.cmd/2,3` or `open_port({spawn_executable, path}, [{args, list}])`
- **Clear** secret env vars in spawned processes: `System.cmd("env", [], env: %{"DB_PASSWORD" => nil})`

### Secret leakage (logs, stacktraces, crash dumps, Observer)
- **Wrap** secrets in zero-arity closures: `fn -> System.get_env("SECRET") end`
- **Derive** or implement `Inspect` on structs holding secrets; implement `format_status/2` on GenServers
- **Use** `:private` ETS tables; `:erlang.process_flag(:sensitive, true)` for short-lived secret-handling processes
- **Prune** stacktrace args: `Plug.Crypto.prune_args_from_stacktrace/1`

### Eval and sandboxing
- **Never** `Code.eval_string/eval_file/eval_quoted` or `file:script` on untrusted input - no in-VM sandbox exists
- **Use** an embedded Lua runtime for user-supplied logic

### Timing attacks
- **Never** compare tokens/MACs/signatures with `==` or pattern matching
- **Use** `Plug.Crypto.secure_compare/2` or `:crypto.hash_equals/2` (OTP 25+)

### TLS clients (`:ssl`, `:httpc` - default is `verify_none`, MITM-open)
- **Set** `verify: :verify_peer`, `cacerts: :public_key.cacerts_get()`, `depth: 2..3`, `customize_hostname_check: [match_fun: :public_key.pkix_verify_hostname_match_fun(:https)]`
- **Test** negatively against badssl.com - failure on bad certs matters more than interop
- **Use** `uri_string:parse/1`, never `http_uri:parse/1` (mints atoms)

### XML (`xmerl`)
- **Never** `xmerl_scan` on untrusted input (tag/attr names become atoms)
- **Raise** on `internalEntityDecl`/`externalEntityDecl` events with `xmerl_sax_parser` (XML bomb, XXE)

### Crypto
- **Prefer** `plug_crypto` or `enacl`/libsodium over raw `crypto` primitives
- **Use** `public_key:sign/verify` over `crypto:sign/verify` for asymmetric keys

### LiveView (full detail: [liveview-security.md](references/liveview-security.md))
- **Validate twice** - plug pipeline for the HTTP request AND `mount`/`on_mount` for the stateful connection; live navigation within a `live_session` skips plugs entirely
- **Attach** `on_mount` hooks at the router: `live_session :default, on_mount: MyAppWeb.UserLiveAuth`; pair with a plug pipeline doing the same checks
- **Authorize** in `mount` (page access) and in every `handle_event` (actions), server-side via context functions - hiding buttons is not authorization
- **Use** `live_session` for authentication boundaries (user vs admin) or root-layout changes, not per-page authorization rules
- **Revoke** live access via `put_session(:live_socket_id, "users_socket:#{user.id}")` + `Endpoint.broadcast(topic, "disconnect", %{})` - live connections outlive logout otherwise

## Part A - Deployment hardening quick reference

Full detail: [deployment-hardening.md](references/deployment-hardening.md)

### Distribution + EPMD (one compromised node = all nodes)
- **Set** `RELEASE_DISTRIBUTION=none` when clustering is not needed
- **Use** TLS distribution with mutual `verify_peer`: `-proto_dist inet_tls -ssl_dist_optfile ...`
- **Bind** to private interfaces: `-kernel inet_dist_use_interface '{...}'`; pin ports via `inet_dist_listen_min/max`
- **Restrict** EPMD: firewall TCP 4369, `ERL_EPMD_ADDRESS`, or `-start_epmd false`
- **Never** connect application tiers via distribution; never pass `-setcookie` on the command line

### Crash and core dumps (contain heap secrets)
- **Set** `ERL_CRASH_DUMP_SECONDS=0` to disable, or redact via Part A secret techniques
- **Disable** OS cores: `ulimit -c 0` / `LimitCORE=0`

### Releases and runtime
- **Ship** OTP releases: embedded code loading, minimal apps, `strip_beams`
- **Run** a maintained OTP version; build with `CFLAGS="-fpie -fstack-protector-strong" LDFLAGS="-pie -z now"`

### Red flags - stop and read the reference
- `binary_to_term` on anything attacker-influenced
- `to_atom` near params, headers, or JSON keys
- `os.cmd` or shell strings; `==` on a token; `:ssl`/`:httpc` without `verify`
- `xmerl_scan` on fetched/uploaded documents; EPMD reachable beyond the cluster

**Run** Sobelow, Credo - already configured in this project; they catch several of the above.

## Part B - Zero Trust (NSA ZIG)

- **Read** [nsa-zig-framework.md](references/nsa-zig-framework.md) for: 7 pillars, ZT principles (never trust always verify, assume breach, verify explicitly), DAAS, maturity model (152 activities / 45 capabilities; Target = Discovery 14 + Phase One 36 + Phase Two 41 = 91 activities, 42 capabilities; Advanced = Phase Three 37 + Phase Four 24), full 91-activity index, PDP/PEP/C2C/segmentation definitions
- **Read** [nsa-zig-phase-details.md](references/nsa-zig-phase-details.md) for: all 42 capability names, per-activity detail with predecessors/successors, cross-cutting requirements (risk-based exceptions, deny-by-default, FIPS 140-3 floor, monitor-before-enforce), risks of incorrect implementation
- **Read** [nsa-zig-technology-capability-mapping.md](references/nsa-zig-technology-capability-mapping.md) for: 117 technologies ↔ 42 capabilities, both directions
- **Cite** exact IDs: capability `pillar.capability` (`4.4`), activity `pillar.capability.activity` (`1.1.1`)
- **Present** ZIG guidance as non-prescriptive recommendations to tailor, never as mandates

## References

- **references/** - Source-faithful data sheets:
  - [secure-coding.md](references/secure-coding.md) - EEF code-level guidance: atoms, serialization, executables, secrets, sandboxing, timing, ssl/inets/crypto/xmerl
  - [deployment-hardening.md](references/deployment-hardening.md) - EEF ops guidance: installing, releases, distribution/EPMD, dumps, tooling
  - [liveview-security.md](references/liveview-security.md) - Phoenix LiveView security model: plug + mount double validation, live_session, on_mount, event authorization, disconnect broadcast
  - [nsa-zig-framework.md](references/nsa-zig-framework.md) - ZIG pillars, principles, phases, full activity index, definitions
  - [nsa-zig-phase-details.md](references/nsa-zig-phase-details.md) - ZIG per-activity detail, cross-cutting requirements, implementation risks
  - [nsa-zig-technology-capability-mapping.md](references/nsa-zig-technology-capability-mapping.md) - technology ↔ capability mapping

Sources: EEF Security WG (security.erlef.org, github.com/erlef/security-wg); Phoenix LiveView "Security considerations" guide (hexdocs.pm/phoenix_live_view); NSA Cybersecurity ZIG (nsa.gov/Cybersecurity/ZIG) + ZIG CTR PDFs (Primer, Discovery, Phase One, Phase Two; Jan 2026).
