# BEAM Deployment Hardening Reference

Source: Erlang Ecosystem Foundation Security Working Group, "Secure Coding and Deployment Hardening Guidelines" (security.erlef.org). Deployment hardening = reducing the attack surface of a production environment (removing unused components, revising unsafe configuration). The usual OS / database / web-server / cloud hardening still applies (CIS Benchmarks) — this covers BEAM-specific concerns.

---

## 1. Installing / building the runtime system

- **Run an actively maintained Erlang/OTP version.** Bug fixes and security patches are officially made available for the latest release only (in practice the last version of the previous major also gets critical fixes for a while). OS-native package repositories may be stuck on outdated OTP — check before relying on them. See the OTP Versions Tree and "Support, Compatibility, Deprecations, and Removal" in the System Principles guide.
- **Ensure patches can be applied quickly.** Some sources ship patches as normal updates; others require the `otp_patch_apply` script. Verify the patch process *before* you need it under time pressure.
- **Enable build hardening** to leverage OS protections (ASLR, stack canaries). When building from source (manually, or via `kerl`/`asdf`), export hardening flags so `beam.smp`, `erlexec` and `epmd` are built with them:
  ```bash
  CFLAGS="-fpie -fstack-protector-strong"
  LDFLAGS="-pie -z now"
  ```
  On Linux, verify with the `hardening-check` tool (from the `devscripts` package on Debian/Ubuntu/Fedora/Red Hat).
- Deployment sources: OS native packages, Erlang Solutions, kerl, asdf, source build, Docker (hexpm images).

---

## 2. Releases

- **Package the project as an OTP release** and **include only the OTP applications needed for production.** A release bundles just the parts of the runtime the app uses, eliminating unnecessary code and shrinking the attack surface.
- **Excluding dev/introspection tools** (`observer`, `runtime_tools`, `compiler`) is a policy decision: removing compilers from production is traditional good practice, but in-place monitor/debug/patch ability is a reason many choose the BEAM. Note Elixir apps always ship the full Elixir standard library including the compiler.
- **Embedded mode (the security win):** in a release the code server runs in embedded mode — modules are loaded once at boot by the boot script and on-demand automatic code loading is disabled. This removes some code-injection paths available to an attacker with limited host access.
- `strip_beams` (default true in Mix releases) removes `debug_info`, hindering decompilation of the artifact.

---

## 3. Distribution protocol and EPMD

**Why it is critical:** The Erlang distribution protocol lets VMs form a cluster. Processes access resources across all nodes (transparently or via RPC). **If one node is compromised, all nodes are.** The protocol is extremely powerful; malicious users must never reach it. Possession of the cluster cookie effectively grants full RCE on every node.

**If you don't need clustering, don't start distribution.** For Mix releases set `RELEASE_DISTRIBUTION=none`. Note that fully disabling distribution is not trivial since everything needed for a distributed node ships in the `kernel` application; `-proto_dist none` *mostly* disables it (node init fails because `none` is invalid).

**Cookie auth is weak.** Default authentication uses cluster cookies — a challenge/response (cookie not sent on the wire), but no protection against active man-in-the-middle attacks, and all application data is transmitted in the clear using a variant of External Term Format. Use a long random cookie via `RELEASE_COOKIE` or a `~/.erlang.cookie` file with mode 0400; avoid `-setcookie` on the command line (visible in `ps`).

**Use TLS for distribution.** Enable strong auth, confidentiality and integrity by running distribution over TLS instead of plain TCP (`ssl` User Guide → "Using TLS for Erlang Distribution"):
- Client options **must** include `{verify, verify_peer}` and `{cacertfile, Path}` pointing to the root CA that issued node certs.
- Mutual TLS is recommended: client certificate plus `{verify, verify_peer}` in the server options.
- Typically: `-proto_dist inet_tls -ssl_dist_optfile /path/ssl_dist.conf` in `vm.args`.

**Network isolation.** Distribution binds to all interfaces by default. Set up a dedicated intra-cluster network (virtual NICs in cloud, VLANs on bare metal) and bind only to it:
- `inet_dist_use_interface` kernel config restricts the bind address (Erlang tuple syntax, e.g. `{127,0,0,1}`).
- Pin the listen port range for firewalling: `-kernel inet_dist_listen_min 9100 -kernel inet_dist_listen_max 9110`.
- **Do not use distributed Erlang to connect tiers** of a multi-tier app (e.g. app→DB layer) — it removes isolation between layers. Keep distribution to horizontal clusters; use constrained interfaces (HTTP, DB APIs) between tiers.

**EPMD (Erlang Port Mapper Daemon, TCP 4369).** Maps node names to distribution ports. The protocol is **unauthenticated**: any client can look up a node by name and retrieve the full list of known nodes plus their ports — leaking your cluster topology. (Real-world: exposed EPMD is a known risk for RabbitMQ and the broader BEAM ecosystem.)
- Firewall 4369 to cluster peers only.
- Restrict listen address with `-address`, `ERL_EPMD_ADDRESS`, or `ERL_EPMD_PORT` (the env var also applies when EPMD is started implicitly by the first node). Note EPMD always also listens on loopback (127.0.0.1, ::1) regardless.
- Eliminate it where possible: `-start_epmd false` (with a custom `-epmd_module`), or run non-distributed.

**Remote shell access without exposing distribution:** use an SSH tunnel or VPN to the Erlang shell. For an unclustered node that only needs remote access via SSH tunnel, bind to loopback:
```bash
ERL_EPMD_ADDRESS=127.0.0.1 erl -sname example -kernel inet_dist_use_interface '{127, 0, 0, 1}'
```

---

## 4. Crash dumps and core dumps

**Crash dumps leak secrets.** A crash dump (`erl_crash.dump`) is written when BEAM terminates abnormally, on `erlang:halt/1,2`, or on `SIGUSR1`. It snapshots application and VM state — including credentials and personal data from process heaps.
- Disable entirely with `ERL_CRASH_DUMP_SECONDS=0` (a positive value bounds how long the write may take). `ERL_CRASH_DUMP_BYTES=0` caps the size. `ERL_CRASH_DUMP=/restricted/path` relocates it to a permissions-restricted directory.
- Disabling dumps makes diagnosing fatal crashes much harder, so in all but the most privacy-sensitive environments prefer to **keep dumps but selectively exclude sensitive data** using the techniques in the secure-coding reference (closures, `process_flag(:sensitive)`, `format_status/2`, private ETS, Inspect masking).

**Core dumps.** Those redaction techniques do **not** cover OS core dumps. Cores are normally root-readable only (some mitigation), but consider disabling them: `ulimit -c 0`, or `LimitCORE=0` in the systemd unit. A core is of limited use anyway — it captures VM state *after* the crash dump is written, not at the moment of failure.

---

## 5. Tooling and further reading

- **Static analysis:** Sobelow (Phoenix-focused security static analysis), Credo (Elixir consistency/teaching).
- **Elixir anti-patterns** (hexdocs `what-anti-patterns`) — e.g. *non-assertive truthiness* can cause logic errors in auth/authz checks. Avoiding anti-patterns means fewer surprises and fewer vulnerabilities.
- **Web (Cowboy/Plug/Phoenix):** OWASP Secure Coding Practices, OWASP Cheat Sheet Series; Plug HTTPS guide and Phoenix "Using SSL".
- **Deployment:** CIS Benchmarks (OS, databases, reverse proxies, container platforms, cloud).
- **Supply chain / ecosystem:** the EEF is a CVE Numbering Authority (CNA) for the Hex and BEAM ecosystem (cna.erlef.org); the Ægis initiative coordinates ecosystem security (Hex.pm security audits, SBOM/provenance work). Track dependency vulnerabilities and keep Hex packages updated.
