# NSA ZIG — Phase One & Phase Two Activity Details

Source: NSA CTRs "Zero Trust Implementation Guideline Phase One" (U/OO/107297-26) and "Phase Two" (U/OO/107298-26), January 2026, v1.0. Companion to `nsa-zig-framework.md` (read that first for pillars, phases, counts, and the full activity index). Every ZIG recommendation is explicitly non-prescriptive; "strongly recommended" is the strongest language used.

---

## 1. The 42 Target-level capabilities (ID → name)

| ID | Capability | ID | Capability |
|---|---|---|---|
| 1.1 | User Inventory | 4.1 | Data Catalog Risk Alignment |
| 1.2 | Conditional User Access | 4.2 | DoW Enterprise Data Governance |
| 1.3 | Multi-Factor Authentication (MFA) | 4.3 | Data Labeling and Tagging |
| 1.4 | Privileged Access Management (PAM) | 4.4 | Data Monitoring and Sensing |
| 1.5 | Identity Federation & User Credentialing | 4.5 | Data Encryption and Rights Management |
| 1.6 | Behavioral, Contextual ID, and Biometrics | 4.6 | Data Loss Prevention (DLP) |
| 1.7 | Least Privileged Access | 4.7 | Data Access Control |
| 1.8 | Continuous Authentication | 5.1 | Data Flow Mapping |
| 1.9 | Integrated ICAM Platform | 5.2 | Software-Defined Networking (SDN) |
| 2.1 | Device Inventory | 5.3 | Macro-Segmentation |
| 2.2 | Device Detection and Compliance | 5.4 | Micro-Segmentation |
| 2.3 | Device Authorization w/ Real-Time Inspection | 6.1 | PDP and Policy Orchestration |
| 2.4 | Remote Access | 6.2 | Critical Process Automation |
| 2.5 | Automated Asset, Vulnerability & Patch Mgmt | 6.3 | Machine Learning |
| 2.6 | UEM & MDM | 6.5 | Security Orchestration, Automation & Response (SOAR) |
| 2.7 | EDR & XDR | 6.6 | API Standardization |
| 3.1 | Application Inventory | 6.7 | SOC and Incident Response (IR) |
| 3.2 | Secure Software Development & Integration | 7.1 | Log All Traffic |
| 3.3 | Software Risk Management | 7.2 | SIEM |
| 3.4 | Resource Authorization & Integration | 7.3 | Common Security and Risk Analytics |
| | | 7.4 | User and Entity Behavior Analytics (UEBA) |
| | | 7.5 | Threat Intelligence Integration |

---

## 2. Phase One — 36 activities (secure foundation, 30 capabilities)

Format: **ID Name** (capability; Pred → Succ). Summary.

### User
- **1.3.1 Organizational MFA & IdP** (1.3; none → none). IdP + MFA for mission-critical apps, integrated with Enterprise PKI (CAC/PIV, FIPS 201 softcerts, FIDO2/YubiKey FIPS hardware tokens; software authenticators only for low-risk). FIPS 140-3 crypto; IdP must support ABAC/RBAC/IBAC for PDP/PEP decisions; logs to SIEM/SOAR.
- **1.4.1 Migrate Privileged Users Pt 1** (1.4; none → 1.4.2). Procure PAM for critical privileged use cases; credential vaulting, job-scoped permissions, phased migration by criticality; risk-based exceptions for non-supporting apps.
- **1.5.1 Organizational ILM** (1.5; none → 1.5.2). Standardized account lifecycle (joiner/mover/leaver) via approved IdP: provisioning, role changes, timely offboarding/credential revocation; annual validation.
- **1.7.1 Deny User by Default** (1.7; none → none). Audit all user/group permissions; revoke excess; decommission static privileged users in favor of dynamic access; apps deny-by-default for role/attribute-gated functions; automate audit/governance.
- **1.8.1 Single Authentication** (1.8; none → 1.2.2, 3.4.1, 3.4.4). MFA at least once per session for users and NPEs; session timeout/termination on inactivity; no application/service-based identities or groups.

### Device
- **2.1.2 NPE & PKI, Device Under Management** (2.1; 2.6.2 → 2.2.1, 2.4.1). X.509 certs to all managed devices and X.509-capable NPEs (servers, network devices, apps). FIPS 140-3 (AES-256, RSA-4096, ECDSA); consider PQC; automated revocation via SOAR; MFA for cert requests.
- **2.4.1 Deny Device by Default** (2.4; 2.1.2 → none). Block all unmanaged devices, local and remote; compliant devices get risk-based access; posture validation via C2C/EDM; centralized exception register with compensating controls; threat emulation to verify blocking.
- **2.5.1 Asset, Vulnerability & Patch Mgmt Tools** (2.5; none → 2.2.1, 3.2.3). Tools confirming compliance with minimum standards (STIGs, C2C, UEM); robust APIs required at procurement; patch testing in controlled environments; vulnerability governance board; triage by severity/exploitability/exposure.
- **2.6.1 Implement UEDM** (2.6; none → none). Unified endpoint/device management: compliance verification, asset management, API support; remote deny/quarantine of non-compliant devices.
- **2.6.2 Enterprise Device Management Pt 1** (2.6; none → 2.1.2, 2.6.3, 3.4.1). Migrate manual inventory to automated EDM; manage devices regardless of location; remote access only through approved central control points (VPN gateways, jump servers, ZTNA); NPE auto-discovery with quarantine.
- **2.7.1 EDR Tools + C2C Integration** (2.7; 2.3.4 → 2.7.2). Procure EDR; feed critical EDR data to Comply-to-Connect; integrate with PAM/IdP/SIEM/SOAR; verify real-time detection (malware, ransomware, anomalies) and response (quarantine, process termination); compensating controls for legacy.

### Application & Workload
- **3.2.1 DevSecOps Software Factory Pt 1** (3.2; none → 3.2.2, 3.2.3). Standardized stack across the SDLC; pipeline-integrated SAST/DAST/SCA/container/IaC scanning + RASP; mandatory code signing; dev/test/prod separation via IaC; tempo + stability metrics (deploy frequency, lead time, MTTR, change-failure rate).
- **3.2.2 DevSecOps Software Factory Pt 2** (3.2; 3.2.1 → 3.5.1). Approved CI/CD for most new apps; PEP/PDP throughout the SDLC; prevent Poisoned Pipeline Execution via two-person rules on all code/tool changes; deny-all-by-default; whitelisted CI/CD libraries; FIPS 140-3 for secrets.
- **3.3.1 Approved Binaries and Code** (3.3; 3.3.2 → none). Supplier sourcing risk management, approved repositories/update channels, SBOMs, code signing + binary scanning, hash verification; AI model artifacts (weights, pipelines) in scope.
- **3.3.2 Vulnerability Management Program Pt 1** (3.3; none → 3.3.1, 3.3.3). Governance team + Enterprise policy; CVE/vendor-bulletin intake; remediation workflows; centralized lifecycle tracking against SLAs.
- **3.4.1 Resource Authorization Pt 1** (3.4; 1.8.1, 2.6.2, 5.3.1 → 3.4.2). Approved authorization gateways (Software-Defined Perimeter pattern) for external-facing apps, integrated with identity + device management; verify apps cannot be reached bypassing gateways; non-migratable apps excepted or decommissioned.
- **3.4.3 SDC Resource Authorization Pt 1** (3.4; 5.3.1 → 3.4.4). Software-defined compute standards: approved code libraries, API gateways within macro-segments, micro-segmented workload access, "normal" API runtime signatures vs anomalies.

### Data
- **4.2.1 Define Data Tagging Standards** (4.2; none → 4.3.1, 4.3.2, 6.3.1). Enterprise control vocabulary + taxonomy mapped to sensitivity classifications; versioned tag libraries; tag-based access control; quarantine untagged files; manual vs automated tag split decided.
- **4.2.2 Interoperability Standards** (4.2; none → 4.5.1). Data-sharing standards incl. mandatory DRM overlays; approved exchange formats/protocols; standardized schemas; machine-to-machine patterns with authn/authz, encryption, audit logging.
- **4.3.1 Data Tagging & Classification Tools** (4.3; 4.2.1 → 4.6.1). Rule-creation/collision-checking tools; tagging at creation/discovery/import; **Global Key Access Store** as centralized tag repository / single source of truth; ML-assisted classification with confidence thresholds and human review.
- **4.4.3 File Activity Monitoring Pt 1** (4.4; none → 4.4.4). FAM on the most critical data classifications; analytics into SIEM; test scenarios (mass downloads, off-hours access, exfiltration patterns); monitoring-only before alerting/enforcement.
- **4.5.1 DRM & Protection Tools Pt 1** (4.5; 4.2.2 → 4.5.2). DRM for high-risk data objects: KMS with identity-restricted keys, encryption at rest/in transit, fine-grained permissions (MFA, ABAC, DLP), geo-restrictions, device binding.
- **4.6.1 Implement Enforcement Points** (4.6; 4.3.1 → 5.4.3). DLP deployed to all identified enforcement points **in monitor-only/learning mode** with standardized logging; privacy impact assessments; attribute injection for origin/boundary-crossing/protection-invocation.

### Network & Environment
- **5.1.2 Granular Access Rules Pt 2** (5.1; 5.1.1 → none). Data-tag-driven API filters; API decision points formalized in the SDN; authentication enforced for all APIs at the API layer; gateways at edge/internal/micro-seg/service-to-service; HTTPS/mTLS everywhere.
- **5.2.2 SDN Programmable Infrastructure** (5.2; 5.2.1, 6.6.2 → none). Three-layer SDN (application/control/infrastructure) via northbound/southbound APIs; **deny all ports by default** ("deny all, permit by exception") with NetFlow baselining, legacy review, phased rollout, rollback; ADC functions (reverse proxy, LB, TLS offload, DDoS, WAF); secure protocols (TLS, SSH, IPsec, SNMPv3, NETCONF).
- **5.3.1 Datacenter Macro-Segmentation** (5.3; none → 3.4.1, 3.4.3, 5.4.1). Logical separation of public from private resources; access enforced at risk boundaries; non-migratable public DAAS to a DMZ via risk-based exception; service-to-service encryption (service mesh, mTLS, OAuth 2.0/OIDC); IDS/IPS + NetFlow + SIEM monitoring.
- **5.4.1 Implement Micro-Segmentation** (5.4; 5.3.1 → 5.4.2). Segment service components (web/app/DB), ports, protocols; distributed NGFW/micro-firewall/endpoint agents in virtual hosting; dynamic policy engines with event-triggered updates; reassess at least annually.

### Automation & Orchestration
- **6.1.2 Organization Access Profile** (6.1; none → 6.1.3). Access-profile rules for DAAS from User/Data/Network/Device pillar data; access levels per role; time/location/frequency conditions; deny-by-default explicit grants; validated via existing PDPs.
- **6.5.2 Implement SOAR Tools** (6.5; 6.6.2, 6.7.1 → none). Standard SOAR requirements → procurement → phased integration starting with ICAM, endpoint protection, segmentation automation; automate access revocation and system isolation in IR.
- **6.6.2 Standardized API Calls & Schemas Pt 1** (6.6; none → 5.2.2, 6.5.2, 6.6.3). Enterprise API standard (OAuth 2.0/OIDC, encryption, logging); API catalog via automated discovery; non-compliant APIs risk-excepted or scheduled for remediation; OpenAPI recommended.
- **6.7.1 Workflow Enrichment Pt 1** (6.7; none → 6.5.2, 6.7.2). IR guidance per NIST CSF; workflows enriched with internal context, past events, CTI (from 7.5.1); CTI-triggered ZT actions (access revocation, segmentation changes, enhanced monitoring); MITRE ATT&CK/D3FEND referenced.

### Visibility & Analytics
- **7.1.2 Log Parsing** (7.1; none → 7.2.4, 7.3.1). Prioritized log/flow sources; Enterprise-standard open log formats (JSON, CEF, Syslog) embedded in procurement; Component Log Source Codex from the Discovery inventories; filter + forward all applicable events to SIEM; encrypted transmission.
- **7.2.1 Threat Alerting Pt 1** (7.2; none → 2.7.2, 7.2.2). SIEM rules/alerts for common threats (malware, phishing); MITRE ATT&CK-informed correlation rules; simulate scenarios pre-production; automate low-risk responses first.
- **7.2.4 Asset ID & Alert Correlation** (7.2; 7.1.2 → none). Asset telemetry (CMDB, EDR, vuln mgmt) integrated with SIEM; alerts enriched with ownership/posture/criticality; flag unmanaged assets (deny-by-default); narrowly scoped Least-Privilege containment over broad shutdowns.
- **7.3.1 Implement Analytics Tools** (7.3; 7.1.2 → none). Analytics across all pillars: continuous trust evaluation, dynamic trust signals (identity behavior, device posture, access anomalies); efficacy metrics (alert accuracy, false-positive reduction).
- **7.5.1 CTI Program Pt 1** (7.5; none → 7.2.2, 7.5.2). CTI policy + Component teams; OSINT/commercial/internal feeds; STIX/TAXII normalization into SIEM; integration points with device/network PEPs-PDPs (NextGen AV, NGFW, NG-IPS); red teaming.

---

## 3. Phase Two — 41 activities (integrate ZT solutions, 34 capabilities)

Phase Two integrates the discrete Phase One solutions: UEBA feeds C2C, tags drive DRM/DLP enforcement, CTI feeds SIEM, baselines feed PDPs.

### User
- **1.2.1 Application-Based Permissions per Enterprise** (1.2; none → none). ICAM governance establishes authoritative user attributes for authn/authz, integrated with Enterprise ILM; PAM attributes identified.
- **1.2.2 Rule-Based Dynamic Access Pt 1** (1.2; 1.1.1, 1.8.1 → 1.2.3, 7.6.1). Rules dynamically enable/disable privileges; ABAC on application functions and data; JIT/JEA extended to all possible admins; annual access audit minimum.
- **1.4.2 Migrate Privileged Users Pt 2** (1.4; 1.4.1 → 1.4.3). PAM extended to legacy/challenging apps; separation of duties; JIT elevation windows; non-supporting systems decommissioned.
- **1.5.2 Enterprise ILM Pt 1** (1.5; 1.5.1 → 1.5.3). Enterprise-wide lifecycle for maximum identities/attributes/credentials; automated provisioning/deprovisioning; JIT auto-revocation.
- **1.6.1 UEBA & UAM Tooling** (1.6; none → 1.3.3, 2.3.1, 7.2.5, 7.3.2, 7.4.1). The most-depended-upon Phase Two activity (5 successors). UEBA + UAM (keystrokes, screen captures, app usage) integrated with Enterprise IdP and correlated to the Master User Record.
- **1.8.2 Periodic Authentication** (1.8; 1.8.1 → 1.8.3, 7.6.1). Session reauthentication by time, behavior, location, data sensitivity; resources tiered low/medium/high criticality with shorter intervals for critical; MFA enrollment for all users.
- **1.9.1 Enterprise PKI & IdP Pt 1** (1.9; none → 1.9.2). Enterprise Root CA + Component intermediates; HSM at FIPS 140-3 Level 3 with M-of-N auth; SHA-256/RSA-2048 minimum; cert validity ~1y (PE) / 2y (NPE); expiry alerts 60/30/15 days; SAML/OAuth/OIDC federation; OCSP.

### Device
- **2.1.3 Enterprise IdP Pt 1** (2.1; none → 2.1.4). NPEs (devices, service accounts) into the Enterprise IdP, tracked in UEM/EDM; static attributes per Least Privilege; non-integrable NPEs retired or excepted.
- **2.2.1 C2C & Compliance-Based Network Authorization Pt 1** (2.2; 2.1.2, 2.3.4, 2.4.2, 2.5.1 → 2.2.2). C2C enforced Component-wide: all mandated checks (patch level, baselines, AV, encryption); PEPs at switches/routers/firewalls; BYOD/IoT/cloud covered; quarantine + remediation flows.
- **2.3.3 Application Control & FIM Tools** (2.3; none → none). Allow/deny listing + file integrity monitoring on all service apps and endpoints, orchestrated with C2C; audit-mode-first; SIEM integration.
- **2.4.2 Managed/Limited BYOD & IoT** (2.4; none → 2.2.1, 2.4.3). BYOD/IoT integrated with Enterprise IdP; dynamic least-privilege policies; risk-based decisions on health, compliance, behavior, context.
- **2.6.3 EDM Pt 2** (2.6; 2.6.2 → none). Remaining devices migrated to Enterprise Device Management; auto-quarantine of non-compliant devices; quarterly quarantine testing; CSSP penetration testing.
- **2.7.2 XDR + C2C Pt 1** (2.7; 2.7.1, 7.2.1 → 2.7.3). XDR replaces/supplements EDR; cross-pillar integration risk-prioritized; normalized data to SIEM; XDR compliance status into C2C.

### Application & Workload
- **3.2.3 Automate AppSec & Code Remediation Pt 1** (3.2; 2.5.1, 3.2.1, 3.3.3 → 3.2.4, 3.4.7). Automated code remediation; secure API gateways (WAF, continuous API testing) carrying the majority of API calls; container security (image scanning in CI/CD, kernel hardening); serverless monitoring; OWASP Top 10 referenced.
- **3.3.3 Vulnerability Management Pt 2** (3.3; 3.3.2 → 3.2.3). Public disclosure processes; closed repositories (DIB-VDP, CERT, CVE); automated threat sharing (ISACs, IoCs, TTPs).
- **3.3.4 Continual Validation** (3.3; none → none). Continuous security validation across the SDLC in CI/CD: threat modeling at planning, SAST at coding, dependency management at build, pen testing at test, IaC at deployment; non-CI/CD apps validated manually.
- **3.4.2 Resource Authorization Pt 2** (3.4; 3.4.1 → none). Authorization gateways (PDP + PEP) extended to ALL apps/services, integrated with IAM and embedded in CI/CD; verify nothing bypasses the gateways; non-migratable apps decommissioned or risk-accepted.
- **3.4.4 SDC Resource Authorization Pt 2** (3.4; 1.8.1, 3.4.3, 5.3.1 → none). Only approved/validated code and binaries run, via SBOM compliance (Name, Version, Supplier, Type, Unique Identifiers/Hash); extends the Master Application Inventory.

### Data
- **4.2.3 Software-Defined Storage Policy** (4.2; none → 4.7.1, 4.7.4). SDS policy/standards: storage tiers by sensitivity/performance/compliance, residency, RPO/RTO, ACLs.
- **4.3.2 Manual Data Tagging Pt 1** (4.3; 4.1.1, 4.2.1 → 4.3.3, 4.5.3, 4.6.2). Enterprise↔Component tag mapping document; most-sensitive-first prioritization; tag inheritance for derivative data; tags consumable by DLP/DRM/SIEM/SOAR.
- **4.4.4 File Activity Monitoring Pt 2** (4.4; 4.4.3 → 4.4.5, 4.4.6). FAM extended to all regulatory-protected data (CUI, PII, PHI); integrated with DLP/DRM/UEBA; per-regulation detection patterns.
- **4.5.2 DRM & Protection Tools Pt 2** (4.5; 4.5.1 → none). DRM expanded to all required data objects ("no data object bypasses the compliance requirement"); auto-encryption at creation; UEBA-driven enforcement.
- **4.5.3 DRM Enforcement via Tags & Analytics Pt 1** (4.5; 4.3.2 → 4.5.4). Tag-driven DRM with ABAC; at-rest encryption by tag; standardize schema (IC-TDF or ZTDF) for cross-Component decryption; keep an unencrypted wrapper so catalogs can scan; KMS with HSM.
- **4.6.2 DLP Enforcement via Tags & Analytics Pt 1** (4.6; 4.3.2 → 4.6.3). **DLP moves from monitor-only to prevention mode**; tag-to-action mappings; controlled-environment testing (accuracy, performance, UX); phased by criticality; rollback procedures.
- **4.7.1 Integrate DAAS Access with SDS Policy Pt 1** (4.7; 4.2.3 → 4.7.2). DAAS access policy per SDS policy; reuse authorization gateways (3.4.1) and SDN segmentation gateways (5.2.2) as PEP/PDP; pilot → publish → enforce.
- **4.7.4 Integrate Solutions/Policy with Enterprise IdP Pt 1** (4.7; 2.1.3, 4.2.3 → 4.7.5, 4.7.6). DLP/DRM/storage interoperate with Enterprise IdP (API, LDAP, SAML); location-based ABAC; continuous attribute sync; CASBs for cloud consistency.

### Network & Environment
- **5.2.3 Segment Control/Management/Data Planes** (5.2; none → 5.3.2, 5.4.2). Physical/logical plane separation; IPv6/VLAN segmentation; load-balanced SDN controller cluster (no single point of compromise); OpenFlow over TLS; FIPS-approved MAC on API messages; deny-by-default for all traffic; DPI at segment boundaries; IaC immutable deployments with rollback.
- **5.3.2 B/C/P/S Macro-Segmentation** (5.3; 5.2.3 → none). Mission/organization-based zones limiting lateral movement (Base/Camp/Post/Station); regional Installation Service Nodes; NAC + ICAM; periodic pen testing; multi-tenancy isolation testing.
- **5.4.2 Application & Device Micro-Segmentation** (5.4; 5.2.3, 5.4.1 → 3.4.5). Logical zones with role/attribute/condition-based access; service mesh with mTLS; workload identity over IP addresses; host agents + HIPS; container orchestration policies; break-glass procedures. Recommended cadences: micro-seg scans quarterly, traffic analysis biannually, breach tabletops annually, log reviews monthly, policy reviews semi-annually.
- **5.4.4 Protect Data in Transit** (5.4; none → none). DiT protection mandated for coalition sharing, cross-system-high boundaries, and between architecture components; Enterprise PKI certs; TLS/IPsec; FIPS 140-3 + PQC awareness; integrity hashing with automated response (session teardown).

### Automation & Orchestration
- **6.1.3 Enterprise Security Profile Pt 1** (6.1; 6.1.2 → 6.1.4). Enterprise profile rules across User/Data/Network/Device pillars; **Service Catalog/CMDB must inventory ZT components — at minimum PDPs, PEPs, PIPs**; version control + rollback for rule updates.
- **6.2.2 Enterprise Integration & Workflow Provisioning Pt 1** (6.2; none → 6.2.3). SOAR integration baseline; bidirectional exchange with EDR/SIEM/IAM/segmentation; requires a Disaster Recovery Plan with automated verification; SOAR-driven recovery (containment, rollback, restoration).
- **6.3.1 ML Data Tagging & Classification Tools** (6.3; 4.2.1 → 4.3.4, 4.3.5). Supervised ML on high-quality tagged subsets with human oversight; confidence scoring routes uncertain cases to SME review; KPIs (precision/recall/false-negative rate); full audit logs; restore-to-known-good.
- **6.6.3 Standardized API Calls & Schemas Pt 2** (6.6; 6.6.2 → none). All ZT services (PEP/PDP/PIP) adopt the Enterprise API standard; drift detection; replacement plans for unprepared services.
- **6.7.2 Workflow Enrichment Pt 2** (6.7; 6.7.1 → 6.7.3). IR workflows extended to advanced incident types (ransomware, insider threat, APT, DDoS); enrichment from UAM/UEBA/profiles/baselines; PDP decision logs and PEP denial logs mapped into workflows; detection → analysis → containment → eradication → recovery → post-incident review.

### Visibility & Analytics
- **7.1.3 Log Analysis** (7.1; none → 7.2.5, 7.3.2). Risk-prioritized activity analytics; **Cyber Risk Scoring (CRS)** with example thresholds 0-30 normal / 31-70 medium (log + alert) / 71-100 high (immediate response); cumulative entity risk with identity stitching; logs produce a risk level per user and device.
- **7.2.2 Threat Alerting Pt 2** (7.2; 7.2.1, 7.5.1 → 7.2.3). SIEM expanded with CTI feeds (STIX/TAXII normalized); anomaly/deviation rules; ZT-bypass threat modeling; IR playbooks per alert type with SOAR automation; metrics: alert volume, false-positive rate, MTTD, MTTR.
- **7.2.5 User and Device Baselines** (7.2; 1.6.1, 7.1.3, 7.3.2 → 1.6.2, 2.3.1). Behavior baselines as benchmark for anomaly detection; strong identity binding (PKI) for non-repudiation; PE attributes (login behavior, location, hours, access patterns) and NPE attributes (communication patterns, workloads); role-based peer-group comparison.
- **7.3.2 Establish User Baseline Behavior** (7.3; 1.6.1, 7.1.3 → 7.2.5, 7.4.1). ML/UEBA differentiating normal from abnormal; identity stitching across accounts/devices; root-cause investigation before enforcement; models trained on healthy-environment history.
- **7.4.1 Baseline and Profiling Pt 1** (7.4; 1.6.1, 7.1.3, 7.3.2 → 7.4.2, 7.4.3). Adaptive threat profiles from baselines + CTI; profiles expire and recalculate; CRS-weighted dynamic risk scoring; profiles integrate into the Organization Access Profile (6.1.2) and are consumable by PDPs; enforcement auditable and reversible.
- **7.5.2 CTI Program Pt 2** (7.5; 7.5.1 → none). CTI teams extended with new stakeholders (COIs); intel mapped to ZTA attack paths informing policy tuning and risk-based access; IAM dynamically adjusts access on threat intel; validated intel → decision → enforcement pathways.

---

## 4. Cross-cutting requirements (recur across both phases)

- **Risk-based exception process** (the strongest recurring pattern): non-conforming items are Identified → Documented → Approved or Rejected; approval only when justification outweighs risk; periodically reassessed; otherwise remediate, replace, or decommission.
- **Deny by default everywhere:** users (1.7.1), devices (2.4.1), network ports/traffic (5.2.2, 5.2.3), resource gateways (verify no bypass — 3.4.1/3.4.2), DAAS profiles (6.1.2), unmanaged assets in SIEM (7.2.4), DRM ("no data object bypasses").
- **Monitor/learning mode before enforcement:** DLP (4.6.1 → 4.6.2), FAM (4.4.3), application control (2.3.3 audit-mode-first), SIEM rules (simulate pre-production).
- **Verify and validate:** every activity ends with verification; all Phase Two work must emit telemetry into Visibility & Analytics and/or Automation & Orchestration solutions.
- **Cryptographic floor:** FIPS 140-3 (Level 3 HSMs + M-of-N for root keys); SHA-256/RSA-2048 minimum (RSA-4096/AES-256/ECDSA for device PKI); FIPS 201 PIV; TLS/mTLS/IPsec/SSH/SNMPv3 transport; Post-Quantum Cryptography awareness per NIST PQC.
- **Inventories as backbone:** Master User Inventory/Record (1.1.1), Master Device Inventory (2.1.1), Master Application Inventory (3.1.1), Master Data Inventory/Catalog (4.1.1), Global Key Access Store (4.3.1), Service Catalog/CMDB with PDP/PEP/PIP inventory (6.1.3).
- **API-first procurement** (robust APIs required in every tool purchase); **open standards over vendor lock-in** (OpenAPI, STIX/TAXII, OAuth 2.0/OIDC, JSON/CEF/Syslog).
- **Two-person rules** on CI/CD code/tool changes (Poisoned Pipeline Execution prevention); **human oversight of ML** (confidence scoring, SME review, audit logs, restore-to-known-good).

## 5. Risks of incorrect implementation (explicit cautions)

- SIEM overwhelmed by unmanaged log ingest (performance, storage cost, slow queries).
- Deny-all rollout without NetFlow baselining, legacy compatibility review, phased rollout, and rollback breaks critical services.
- DLP/DRM/FAM enforced without monitor-only baselining disrupts business operations; test tag-recognition accuracy and UX impact first.
- SDN controller as a single point of compromise — use load-balanced clusters and vetted updates.
- Retaining local/built-in accounts undermines MFA/IdP (their retirement is "critical").
- ML mis-tagging at scale — confidence scoring, human review, restore procedures.
- Over-broad exceptions erode the model — periodic reassessment is mandatory.
- Broad shutdowns instead of narrowly scoped least-privilege containment.
- Encrypted data becoming unscannable/unshareable — standardized IC-TDF/ZTDF schema + unencrypted wrapper.
- Micro-segmentation locking out operations — break-glass procedures.
- Unverified external threat/enrichment feeds polluting enforcement decisions.
- Untested API standard rollout breaking integrations — controlled-environment testing, backward compatibility for legacy.
