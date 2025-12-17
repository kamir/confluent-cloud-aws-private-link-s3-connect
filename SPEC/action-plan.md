# Action Plan - Kafka Connect Operations Documentation

**Meeting Date:** 2025-12-11
**Plan Created:** 2025-12-17
**Status:** In Progress

---

## Meeting Action Items Tracking

### ✅ Action Item 1: Create sketch and design document detailing deployment procedure and operational model

**Status:** COMPLETED

**Deliverables Created:**

1. **customer-requirements.md** - Comprehensive operational model documentation including:
   - Three-party model diagram (EBS, Departments, Confluent)
   - Detailed role definitions (EBS Infrastructure Team, Department Connector Operator, Department Developer)
   - Deployment workflow sequence diagrams for:
     - GitOps model (EBS-managed deployment)
     - Self-service CLI model
   - Hybrid model recommendation
   - Network connectivity establishment flowchart
   - Troubleshooting workflow
   - Lifecycle state machine diagram
   - Role interaction matrix

**Location:** `/SPEC/customer-requirements.md`

**Key Sections:**
- Section 3.1: Deployment Options (GitOps vs CLI)
- Section 4: Operational Workflows (with Mermaid diagrams)
- Section 7: Infrastructure Provisioning (EBS responsibility)
- Appendix A: Role Interaction Matrix
- Appendix B: Decision Matrix for deployment models

---

### ✅ Action Item 2: Document end-to-end process for customers (request, start, manage connectors)

**Status:** COMPLETED

**Deliverables Created:**

1. **customer-requirements.md** sections covering:
   - Section 4.1: Connector Deployment Flow (GitOps) - **Sequence diagram**
   - Section 4.2: Connector Deployment Flow (Self-Service CLI) - **Sequence diagram**
   - Section 4.3: Network Connectivity Establishment - **Flowchart**
   - Section 4.4: Troubleshooting Workflow - **Flowchart**
   - Section 6: Connector Lifecycle Management
     - Lifecycle state machine diagram
     - Operations matrix (Create, Read, Update, Pause, Resume, Delete)
   - Section 7.2: Department Onboarding Process (step-by-step)

2. **requirements.md** - Episode-based learning path structure:
   - Episode 04: Deploying Test Connector (step-by-step)
   - Episode 05: Pipeline Testing (end-to-end testing guide)
   - Episode 06: GitOps Workflow (Git repo structure, PR process, deployment)
   - Episode 07: Monitoring and Logging
   - Episode 08: Production Deployment

**GitOps Process Documented:**
```
Developer commits config → PR triggers validation → EBS reviews →
Merge triggers deployment → Terraform/CLI execution → Health dashboard updated
```

**Self-Service CLI Process Documented:**
```
Department operator → Confluent CLI → Restricted API key → RBAC validation →
Connector deployed → Status via CLI/dashboard
```

**Location:**
- `/SPEC/customer-requirements.md` (Sections 4-7)
- `/SPEC/requirements.md` (Section 5: GitOps workflow details)

---

### 🔶 Action Item 3: Investigate connector quotas and enforcement options

**Status:** PARTIALLY COMPLETED - Documented investigation plan and alternatives

**What's Been Documented:**

1. **customer-requirements.md** - Section 5.1: Quota Management
   - Identified the challenge: "Kafka Connect may not have built-in per-tenant quotas"
   - Documented three solution options:
     - **Option 1:** Confluent Cloud Native Quotas (if available)
     - **Option 2:** Custom Validation Script (GitOps pipeline)
     - **Option 3:** RBAC-Based Isolation (dedicated clusters)
   - Provided sample code for custom validation
   - Recommendation: Start with custom validation, migrate to native if available

2. **gap-analysis-and-recommendations.md** - Identified as missing component

3. **Open questions documented** in Section 10:
   - "Does Confluent Cloud support per-service-account connector quotas?"
   - "If yes, how to configure via Terraform?"
   - "If no, timeline for this feature?"

**What Still Needs Investigation:**

- [ ] **Test Confluent Cloud API/CLI for quota capabilities**
  ```bash
  # Commands to test:
  confluent connect cluster describe <cluster-id>
  confluent connect cluster quota --help
  # Check Terraform provider docs for quota resource
  ```

- [ ] **Review Confluent Cloud documentation**
  - Search for "connector quotas" in docs
  - Check Terraform provider changelog for quota support
  - Review API reference for quota endpoints

- [ ] **Fallback: Document custom quota enforcement implementation**
  - Python/Bash script to check current connector count
  - Integration with GitOps validation pipeline
  - Quota configuration file format (quotas.yaml)

**Recommendation:** Assign to team member to research and test within 1 week

---

### 🔶 Action Item 4: Engage Confluent engineering about log export and metrics APIs

**Status:** DOCUMENTED AS FEATURE REQUEST - Not yet engaged

**What's Been Documented:**

1. **customer-requirements.md** - Section 5.3: Logging and Monitoring Strategy
   - **Three-tier logging strategy defined:**
     - Tier 1: Department self-service via CLI (limited)
     - Tier 2: Health check dashboard (status only)
     - Tier 3: Full logs via Dynatrace (EBS only)

   - **Feature request drafted:**
     ```
     Request: Export Kafka Connect logs from fully managed clusters

     Options requested:
     1. Stream logs to customer-owned Kafka topic
     2. Push logs to CloudWatch Logs
     3. Expose logs via API endpoint
     4. Enable log forwarding to external systems
     ```

2. **customer-requirements.md** - Section 5.4: Metrics Integration
   - Documented required metrics (connector-level, task-level, source/sink)
   - Integration architecture with Dynatrace
   - Alert examples

3. **Open Questions documented** in Section 10:
   - "Can fully managed Connect export logs to customer-owned Kafka topic?"
   - "Can logs be forwarded to CloudWatch/Dynatrace?"
   - "What is Confluent's roadmap for log observability?"

**What Still Needs to Be Done:**

- [ ] **Open Confluent Support Case**
  - Title: "Log Export Options for Fully Managed Kafka Connect"
  - Reference: Three-tier logging strategy from customer-requirements.md
  - Ask specifically about:
    - Log streaming to Kafka topic
    - CloudWatch Logs integration
    - API endpoints for log retrieval
    - Webhook notifications for errors

- [ ] **Schedule Confluent Solutions Architect Call**
  - Present use case: Multi-tenant environment without UI access
  - Discuss log visibility options
  - Request product roadmap information
  - Explore partnership/beta program for log features

- [ ] **Investigate Workarounds**
  - Check if Connect logs appear in `_confluent-monitoring` topics
  - Test API endpoints for connector error messages
  - Evaluate CLI `confluent connect describe` output comprehensiveness

- [ ] **Document API-Based Monitoring**
  - Which metrics are available via Confluent Cloud Metrics API
  - Sample code for polling connector status
  - Integration examples for health dashboard

**Recommendation:** EBS team to open support case and schedule SA call within 1 week

---

## Additional Deliverables Created (Beyond Meeting Scope)

### gap-analysis-and-recommendations.md

**Purpose:** Comprehensive analysis of current Terraform blueprint vs. requirements

**Key Contents:**
- Current state assessment (what exists)
- 11 critical gaps identified:
  1. No Kafka Connect cluster
  2. No connector configurations
  3. Missing IAM roles and policies
  4. Incomplete egress Private Link setup
  5. No service account for connectors
  6. Missing connector internal topics
  7. No DLQ configuration
  8. No secret management integration
  9. No monitoring/logging setup
  10. No CI/CD pipeline
  11. No developer documentation

- Priority-based recommendations (P1/P2/P3)
- Implementation roadmap (6-8 weeks)
- **Answers to user's three key questions:**
  - How can developer test pipeline?
  - How can developer access logs when deployed via CLI?
  - How to manage configs via GitOps?

**Location:** `/SPEC/gap-analysis-and-recommendations.md`

---

### requirements.md

**Purpose:** General requirements document (not customer-specific)

**Key Contents:**
- Functional requirements
- Deployment methods
- Access control and security
- Monitoring and logging requirements
- Testing and development workflows
- **Episode-based learning path structure** (10 episodes)
  - Episode 01: Getting Started
  - Episode 02: Understanding Architecture
  - Episode 03: Developing Connectors
  - Episode 04: Deploying Test Connector
  - Episode 05: Pipeline Testing
  - Episode 06: GitOps Workflow
  - Episode 07: Monitoring and Logging
  - Episode 08: Production Deployment
  - Episode 09: Connector Examples
  - Episode 10: Troubleshooting Guide

**Location:** `/SPEC/requirements.md`

---

## Summary: Action Items Status

| Action Item | Owner | Status | Deliverable | Next Step |
|-------------|-------|--------|-------------|-----------|
| 1. Design document & deployment procedure | Speaker 1 | ✅ COMPLETE | customer-requirements.md (Sections 3-4) | Review & feedback |
| 2. End-to-end process documentation | Speaker 1 | ✅ COMPLETE | customer-requirements.md (Sections 4-7), requirements.md (Episodes) | Review & feedback |
| 3. Investigate connector quotas | Speaker 1 | 🔶 DOCUMENTED | customer-requirements.md (Section 5.1) | Test in Confluent Cloud |
| 4. Engage Confluent on logs/metrics | Speaker 1 | 🔶 DOCUMENTED | customer-requirements.md (Section 5.3-5.4) | Open support case |

**Legend:**
- ✅ = Complete
- 🔶 = Documented but requires follow-up action
- ❌ = Not started

---

## Next Steps (Priority Order)

### Week 1: Validation & Research

1. **Review Documentation** (Speaker 2 + Team)
   - [ ] Review all three SPEC documents
   - [ ] Provide feedback on operational model
   - [ ] Validate deployment workflows
   - [ ] Confirm role definitions

2. **Technical Investigation** (Speaker 1 or assigned team member)
   - [ ] Test Confluent Cloud quota capabilities
   - [ ] Open Confluent support case for log export
   - [ ] Schedule Confluent SA call
   - [ ] Document findings in action-plan.md

### Week 2: Terraform Implementation

3. **Complete Terraform Modules** (Based on gap-analysis.md)
   - [ ] Module: kafka-connect-cluster
   - [ ] Module: connector (generic template)
   - [ ] Module: iam-connector-roles
   - [ ] Module: department-onboarding
   - [ ] Test with pilot department

### Week 3-4: Tooling & Automation

4. **Build Validation Pipeline**
   - [ ] Quota validation script
   - [ ] Naming convention validation
   - [ ] Set up Git repository structure
   - [ ] CI/CD pipeline for GitOps

5. **Monitoring Integration**
   - [ ] Confluent metrics → Dynatrace
   - [ ] Build health check dashboard
   - [ ] Configure alerts

### Week 5-6: Documentation & Training

6. **Create Episode Content** (Based on requirements.md structure)
   - [ ] Write Episode 01-04 (Getting started → Testing)
   - [ ] Write Episode 05-07 (Pipeline → Monitoring)
   - [ ] Write Episode 08-10 (Production → Troubleshooting)
   - [ ] Create architecture diagrams

7. **Pilot Program**
   - [ ] Onboard first department
   - [ ] Test end-to-end workflow
   - [ ] Collect feedback
   - [ ] Refine procedures

---

## Open Questions & Dependencies

### Critical Blockers

1. **Confluent Quota Support**
   - **Impact:** Without native quotas, need custom solution
   - **Timeline:** Research required within 1 week
   - **Owner:** TBD

2. **Log Export Capability**
   - **Impact:** Limited troubleshooting for departments
   - **Timeline:** Support case + SA call within 1 week
   - **Owner:** EBS team

3. **RBAC Granularity**
   - **Question:** Can RBAC enforce connector name prefixes?
   - **Impact:** Determines if CLI self-service is viable
   - **Timeline:** Test within 1 week
   - **Owner:** TBD

### Nice-to-Have

4. **Schema Registry Integration**
   - Not blocking, but enhances solution
   - Document later in Episode 09

5. **Multi-Environment Strategy**
   - Dev/Staging/Prod separation
   - Can be phased in after pilot

---

## Success Criteria (from Meeting)

- [x] Operational model clearly defined
- [x] Deployment procedures documented with diagrams
- [ ] Quota enforcement solution identified (research in progress)
- [ ] Log access strategy defined (documented, pending Confluent engagement)
- [x] GitOps workflow detailed
- [ ] Pilot department successfully onboarded (pending implementation)

---

## AI-Identified Issues (from Meeting Summary)

### Issue 1: Log access for customers undecided

**Status:** ✅ ADDRESSED
- Three-tier logging strategy documented
- Feature request drafted for Confluent
- Workarounds identified (CLI, health dashboard)
- Action item: Open support case

### Issue 2: Resource management on shared clusters unresolved

**Status:** ✅ ADDRESSED
- Quota enforcement options documented
- Custom validation approach defined
- Isolation strategy levels documented (shared/dedicated)
- Action item: Research native quota support

### Issue 3: Exact permissions and tooling for end-users under discussion

**Status:** ✅ ADDRESSED
- Two deployment models documented (GitOps vs CLI)
- Hybrid approach recommended
- RBAC requirements specified
- API key distribution process outlined
- Action item: Test RBAC capabilities

---

## Appendix: Document Cross-Reference

| Topic | Primary Document | Section |
|-------|-----------------|---------|
| Three-party operational model | customer-requirements.md | Section 1 |
| Role definitions | customer-requirements.md | Section 2 |
| Deployment workflows | customer-requirements.md | Section 4 |
| GitOps process | customer-requirements.md | Section 4.1 |
| CLI self-service process | customer-requirements.md | Section 4.2 |
| Quota enforcement | customer-requirements.md | Section 5.1 |
| Logging strategy | customer-requirements.md | Section 5.3 |
| Metrics integration | customer-requirements.md | Section 5.4 |
| Lifecycle management | customer-requirements.md | Section 6 |
| Terraform modules | gap-analysis-and-recommendations.md | Section 9 |
| Critical gaps | gap-analysis-and-recommendations.md | Section 8 |
| Episode learning path | requirements.md | Section 4.3 |
| Testing procedures | gap-analysis-and-recommendations.md | Section 9 |

---

## Communication Plan

### For Speaker 2 Review:

**Email Subject:** Kafka Connect Operations Documentation - Ready for Review

**Email Body:**
```
Hi [Speaker 2],

I've completed the documentation for the Kafka Connect operational model as discussed in our meeting on 2025-12-11.

**Deliverables:**

1. **customer-requirements.md** - Operational model with role definitions, workflows, and diagrams
2. **gap-analysis-and-recommendations.md** - Current state analysis and implementation roadmap
3. **requirements.md** - General requirements and episode-based learning structure

**Key Highlights:**
- Three-party model clearly defined (EBS, Departments, Confluent)
- Two deployment options documented: GitOps (controlled) and CLI self-service (scalable)
- Hybrid approach recommended for best of both worlds
- Quota enforcement strategy (pending Confluent research)
- Three-tier logging strategy (pending Confluent engagement)

**Next Steps Required:**
1. Review documents and provide feedback
2. Assign owner for Confluent quota research
3. Open Confluent support case for log export options
4. Schedule Confluent SA call

**Location:** /SPEC/ folder in repository

Please review at your convenience. Happy to schedule a walkthrough if needed.

Best regards,
[Speaker 1]
```

---

**Document Version:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-17 | Infrastructure Team | Initial action plan based on meeting notes |

