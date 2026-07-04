# NSA Zero Trust — Technology-to-Capability Mapping

Source: NSA Cybersecurity Zero Trust Implementation Guidelines (ZIG), interactive "Technology–Capability Mapping" (nsa.gov/Cybersecurity/ZIG/Technology-Mapping).

**Status disclaimer (verbatim intent):** This mapping is a reference aid for exploration, planning, and discussion. It is **not authoritative, exhaustive, or prescriptive** and may not list every technology that can support a capability. Technology lists in the ZIGs are representative and vendor-agnostic.

Coverage: **117 technologies → 42 distinct capabilities** across the 7 Zero Trust pillars. Capability IDs use `pillar.capability` (e.g. `4.4`); the `P#` tag is the pillar. Pillars: P1 User, P2 Device, P3 Application & Workload, P4 Data, P5 Network & Environment, P6 Automation & Orchestration, P7 Visibility & Analytics.

---

## Technologies → capabilities (alphabetical)

| Technology | Capabilities |
|---|---|
| Anomaly Detection | 4.4, 5.1 |
| API Gateway and Management solutions | 5.1 |
| API Integration Frameworks | 5.1 |
| API Management solutions | 6.6 |
| Application Portfolio Management (APM) | 3.1 |
| Application Security Testing Orchestration (ASTO) | 3.2 |
| AI/ML-Based Tagging and User Behavior Analysis | 6.3, 7.4 |
| Asset Management solutions | 3.1 |
| Asset/Device/Endpoint Management solutions | 2.1, 2.6 |
| Attribute-Based Access Control (ABAC) | 1.2, 1.5, 1.7, 3.4, 4.7, 6.1 |
| Audit and Logging | 1.6, 1.7, 1.8 |
| Automated Provisioning/Deprovisioning | 1.5 |
| Automation Frameworks and Libraries | 6.2 |
| Automation Orchestration solutions | 6.2 |
| Behavioral Analytics solutions | 4.4, 5.1, 6.3 |
| Cloud Access Security Broker (CASB) | 2.2, 2.4 |
| Cloud Security Platforms | 1.7 |
| Cloud Security Posture Management (CSPM) | 2.2 |
| Code Signing | 3.2 |
| Compliance Management solutions | 4.1 |
| Compliance and Governance Automation solutions | 4.1 |
| Comply-to-Connect (C2C) | 2.2 |
| Configuration Management Database (CMDB) | 2.1, 2.5, 3.1 |
| Container Security Scanning | 3.3 |
| Containerization and Orchestration Tools | 3.2 |
| Content Inspection solutions | 4.3 |
| Context-Aware Access Control | 4.7 |
| Continuous Integration/Continuous Delivery (CI/CD) Pipelines | 6.2 |
| Cyber Threat Intelligence (CTI) ingestion from multiple approved sources | 6.6 |
| Cyber Threat Modeling | 6.3 |
| Data Analytics and Visualization solutions | 7.3 |
| Data Classification, Discovery, Labeling solutions | 4.3 |
| Data Encryption | 4.5 |
| Data Integration and Extract, Transform, Load (ETL) | 6.6 |
| Data Lifecycle Management | 4.2 |
| Data Loss Prevention (DLP) | 1.4, 4.4, 4.6 |
| Data Management and Integration | 4.1 |
| Data Standardization | 4.2, 4.3, 6.3 |
| Data Tagging and Protection | 4.3, 4.6 |
| Device Health Monitoring | 2.2, 2.6 |
| Digital Rights Management (DRM) | 4.4, 4.5, 4.7 |
| Disaster Recovery and Business Continuity solutions | 6.2 |
| Dynamic Application Security Testing (DAST) | 3.2, 3.3 |
| Encryption and Key Management solutions | 1.3, 1.4, 4.5 |
| Endpoint Detection and Response (EDR) | 1.6, 1.8, 2.4, 2.7, 6.5 |
| Endpoint Protection Platform (EPP) | 6.7 |
| Endpoint Security solutions | 1.6 |
| Enterprise Mobility Management | 2.4, 2.6 |
| Extended Detection and Response (XDR) | 2.7, 6.5 |
| File Integrity Monitoring (FIM) | 2.3, 4.4, 4.6 |
| Firewall as a Service (FWaaS) | 5.4 |
| Git Security and Governance | 3.3 |
| Governance, Risk, and Compliance (GRC) | 4.1, 4.2, 7.2, 7.3, 7.5 |
| Identity Governance and Administration (IGA) | 1.5 |
| Identity Management (IdM) | 1.1 |
| Identity Provider (IdP) | 1.1, 1.3, 1.9 |
| Identity and Access Management (IAM) | 6.1, 7.4 |
| Identity as a Service (IDaaS) | 1.2, 1.3, 1.9 |
| Identity-Based Access Control (IBAC) | 6.1 |
| Identity, Credential, and Access Management (ICAM) | 1.1, 1.2, 1.4, 1.9, 3.4 |
| Incident Response (IR) | 4.6 |
| Indicators of Compromise (IoC) | 6.7 |
| Infrastructure as Code (IaC) Config Mgmt / Security Monitoring and Auditing | 3.2 |
| Internet Protocol Security (IPsec) | 5.2 |
| Internet of Things (IoT) Discovery | 2.1 |
| Interoperability Standards and Protocols | 6.6 |
| Interoperability and Data Exchange Frameworks | 4.2 |
| Intrusion Detection Systems (IDS)/Intrusion Prevention Systems (IPS) | 2.7, 5.3, 7.1, 7.5 |
| Inventory and Asset Management solutions | 2.1 |
| IT Asset Management (ITAM) Software | 2.1, 2.5 |
| Just Enough Access (JEA) | 1.4 |
| Just-in-Time (JIT) Access | 1.4, 1.7, 1.8, 4.7 |
| Log Management solutions | 7.1 |
| Macro-Segmentation | 5.2, 5.3 |
| Managed Detection and Response (MDR) | 2.7, 6.2, 7.2, 7.3, 7.5 |
| Metadata Management solutions | 4.1, 4.3 |
| Micro-Segmentation | 5.2, 5.3, 5.4 |
| Microservices APIs | 6.6 |
| Mobile Device Management (MDM) | 2.4, 2.6 |
| Monitoring and Analytics solutions | 4.4, 5.1 |
| Monitoring and Auditing solutions | 7.1 |
| Multi-Factor Authentication (MFA) | 1.3, 1.8, 1.9, 2.3, 6.7, 7.4 |
| Network Access Control (NAC) | 2.2, 2.3, 2.4, 5.4 |
| Network Function Virtualization (NFV) | 5.2 |
| Network Flow Data | 7.1 |
| Network Traffic Analysis (NTA) | 7.1 |
| Network Virtualization | 5.2 |
| Next-Generation Antivirus (NextGen AV) | 2.3, 2.6, 2.7 |
| Next-Generation Firewall (NGFW) | 5.3 |
| Patch Management solutions | 2.5 |
| Platform as a Service (PaaS) | 1.2 |
| Policy Decision Points (PDPs) | 4.2, 4.7, 5.3, 6.1, 6.5 |
| Policy Enforcement Points (PEPs) | 3.4, 4.2, 4.6, 5.3, 6.1, 6.5 |
| Privileged Access Management (PAM) | 1.4, 1.7, 6.7 |
| Public Key Infrastructure (PKI) | 1.3, 1.9, 2.3 |
| Real-Time Monitoring | 2.3 |
| Role-Based Access Control (RBAC) | 1.2, 1.4, 1.5, 1.7, 3.4, 6.1, 7.4 |
| Runtime Application Self-Protection (RASP) | 4.5 |
| Security Information and Event Management (SIEM) | 6.5, 7.2 |
| Security Orchestration, Automation, and Response (SOAR) | 2.5, 3.4, 6.5, 7.5 |
| Single Sign-On (SSO) and Federation | 1.5 |
| Software Asset Management (SAM) | 3.1 |
| Software Composition Analysis (SCA) | 3.3 |
| Security Content Automation Protocol (SCAP) | 2.2 |
| Software-Defined Networking (SDN) | 5.4 |
| Source Code Management (SCM) | 3.1 |
| Static Application Security Testing (SAST) | 3.2, 3.3 |
| Structured Threat Information eXpression (STIX) protocols | 6.1 |
| System Cross-Domain Identity Management (SCIM) | 1.1 |
| Threat Intelligence Platform (TIP) | 5.1, 6.7, 7.2, 7.3, 7.5 |
| Traffic Filtering and Inspection | 5.2 |
| Trusted Automated Exchange of Intelligence Information (TAXII) | 6.1 |
| Trusted Execution Environment (TEE) | 4.5 |
| User Activity Monitoring (UAM) | 1.6, 7.4 |
| User and Entity Behavior Analytics (UEBA) | 1.6, 1.8, 6.3, 7.3, 7.4 |
| Virtual Extensible Local Area Network (VXLAN) | 5.4 |
| Vulnerability Management solutions | 2.5, 7.2, 7.3 |

---

## Reverse view: capabilities → representative technologies

**P1 User** — 1.1 Identity inventory: IdM, IdP, ICAM, SCIM. 1.2 Conditional access: ABAC, RBAC, IDaaS, ICAM, PaaS. 1.3 MFA/credentialing: MFA, IdP, IDaaS, PKI, Encryption & Key Mgmt. 1.4 Privileged access: PAM, JIT, JEA, DLP, RBAC, ICAM, Encryption & Key Mgmt. 1.5 Identity lifecycle: IGA, SSO/Federation, Automated Provisioning, ABAC, RBAC. 1.6 Behavioral/UAM: UEBA, UAM, EDR, Endpoint Security, Audit & Logging. 1.7 Least privilege: ABAC, RBAC, PAM, JIT, Audit & Logging, Cloud Security Platforms. 1.8 Continuous authentication: MFA, JIT, EDR, UEBA, Audit & Logging. 1.9 Integrated ICAM: IdP, IDaaS, ICAM, PKI, MFA.

**P2 Device** — 2.1 Device inventory: Asset/Device/Endpoint Mgmt, CMDB, ITAM, IoT Discovery, Inventory & Asset Mgmt. 2.2 Compliance-based authorization: CASB, CSPM, C2C, NAC, SCAP, Device Health Monitoring. 2.3 Real-time inspection: FIM, MFA, PKI, NAC, NextGen AV, Real-Time Monitoring. 2.4 Managed/BYOD: CASB, MDM, Enterprise Mobility Mgmt, NAC, EDR. 2.5 Asset/vuln/patch: ITAM, CMDB, Patch Mgmt, Vulnerability Mgmt, SOAR. 2.6 Unified endpoint mgmt: Asset/Device/Endpoint Mgmt, Device Health Monitoring, MDM, Enterprise Mobility Mgmt, NextGen AV. 2.7 EDR/XDR: EDR, XDR, IDS/IPS, NextGen AV, MDR.

**P3 Application & Workload** — 3.1 Application inventory: APM, Asset Mgmt, CMDB, SAM, SCM. 3.2 DevSecOps software factory: ASTO, Code Signing, Containerization & Orchestration, DAST, SAST, IaC. 3.3 Vulnerability mgmt / approved code: Container Security Scanning, DAST, SAST, SCA, Git Security & Governance. 3.4 Resource authorization: ABAC, RBAC, ICAM, PEPs, SOAR.

**P4 Data** — 4.1 Data catalog risk alignment: Compliance Mgmt, Compliance & Governance Automation, Data Mgmt & Integration, GRC, Metadata Mgmt. 4.2 Tagging standards/interoperability: Data Lifecycle Mgmt, Data Standardization, GRC, Interoperability & Data Exchange, PDPs, PEPs. 4.3 Data tagging/classification: Content Inspection, Data Classification/Discovery/Labeling, Data Standardization, Data Tagging & Protection, Metadata Mgmt. 4.4 Data monitoring/sensing: Anomaly Detection, Behavioral Analytics, DLP, DRM, FIM, Monitoring & Analytics. 4.5 Data encryption/DRM: Data Encryption, DRM, Encryption & Key Mgmt, RASP, TEE. 4.6 Enforcement points: DLP, Data Tagging & Protection, FIM, IR, PEPs. 4.7 DAAS access integration: ABAC, Context-Aware Access Control, DRM, JIT, PDPs.

**P5 Network & Environment** — 5.1 Data flow mapping: Anomaly Detection, API Gateway & Mgmt, API Integration Frameworks, Behavioral Analytics, Monitoring & Analytics, TIP. 5.2 SDN: IPsec, Macro-Segmentation, Micro-Segmentation, NFV, Network Virtualization, Traffic Filtering & Inspection. 5.3 Macro-segmentation: IDS/IPS, Macro-Segmentation, Micro-Segmentation, NGFW, PDPs, PEPs. 5.4 Micro-segmentation: FWaaS, Micro-Segmentation, NAC, SDN, VXLAN.

**P6 Automation & Orchestration** — 6.1 PDP/policy orchestration: ABAC, IAM, IBAC, RBAC, PDPs, PEPs, STIX, TAXII. 6.2 Critical process automation: Automation Frameworks & Libraries, Automation Orchestration, CI/CD Pipelines, DR & BC, MDR. 6.3 ML tagging/behavior: AI/ML Tagging & UBA, Behavioral Analytics, Cyber Threat Modeling, Data Standardization, UEBA. 6.5 SOAR: EDR, XDR, PDPs, PEPs, SOAR, SIEM. 6.6 API standardization: API Mgmt, CTI ingestion, Data Integration & ETL, Interoperability Standards & Protocols, Microservices APIs. 6.7 Workflow enrichment: EPP, IoC, MFA, PAM, TIP.

**P7 Visibility & Analytics** — 7.1 Log all traffic: IDS/IPS, Log Mgmt, Monitoring & Auditing, Network Flow Data, NTA. 7.2 Threat alerting: GRC, IDS/IPS, MDR, SIEM, TIP, Vulnerability Mgmt. 7.3 Analytics: Data Analytics & Visualization, GRC, MDR, TIP, UEBA, Vulnerability Mgmt. 7.4 Baseline/profiling: AI/ML Tagging & UBA, IAM, MFA, RBAC, UAM, UEBA. 7.5 Cyber threat intelligence: GRC, IDS/IPS, MDR, SOAR, TIP.

---

## How to use this mapping

- It answers "which technology categories enable capability X" and "which capabilities does technology Y support" — for planning and gap analysis, not as a compliance checklist.
- Cross-reference capability descriptions and the activities that build them in the ZIG overview reference and the per-phase activity lists.
- A technology appearing under many capabilities (e.g. ABAC, RBAC, MFA, PEPs, PDPs, EDR, SOAR, TIP, GRC, UEBA, Micro-Segmentation) is a high-leverage investment touching multiple pillars.
