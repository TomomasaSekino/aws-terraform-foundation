# AWS Terraform Foundation

Enterprise-oriented AWS infrastructure foundation built with Terraform.

---

## Overview

This repository provides a reusable AWS VPC foundation designed for:

- On-premises to cloud migration
- Standardized infrastructure design
- Incident recurrence prevention
- Environment isolation (dev / prod ready structure)

The objective is not just provisioning infrastructure, but creating systems that remain stable and maintainable without continuous human dependency.

---

## Architecture

### Components

- VPC (custom CIDR)
- Public Subnets (Multi-AZ)
- Private Subnets (Multi-AZ)
- Internet Gateway
- NAT Gateway (single NAT for dev cost optimization)
- Route Tables
- Tagging strategy for governance readiness

### Logical Layout

```
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Public Subnet ─── NAT Gateway ─── Private Subnet
```

---

## Repository Structure

```
aws-terraform-foundation/
  envs/
    dev/
      main.tf
      variables.tf
      locals.tf
      providers.tf
      outputs.tf
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
  docs/
```

### Structure Philosophy

- `envs/` → Environment-specific execution model
- `modules/` → Reusable and composable infrastructure units
- `docs/` → Design decisions and architecture reasoning

This separation ensures that production environments can be added without structural refactoring.

---

## Design Principles

- Explicit environment isolation
- Reusable modular components
- Naming convention: `<env>-<project>-<resource>`
- Tag-based governance (Env / Project / Owner)
- Reproducible builds
- Safe validation workflow (`plan → apply → destroy`)
- Cost-aware design decisions in non-production environments

Infrastructure should eventually operate independently of individual operators.

---

## Execution

```bash
cd envs/dev
terraform init
terraform plan
terraform apply
terraform destroy
```

⚠ NAT Gateway incurs hourly cost. Always run `terraform destroy` after testing.

---

## Technical Context

This repository represents the application of structured enterprise infrastructure thinking into Infrastructure as Code.

Background includes:

- 20+ years enterprise infrastructure experience
- AIX / Linux / SAN / SAP environments
- High availability and disaster recovery design
- Root cause analysis and recurrence prevention
- Standardization and operational governance

The focus is on translating operational discipline from on-premises environments into cloud-native architectures.

---

## Future Expansion

- ECS Fargate integration
- RDS / Aurora module
- Observability integration (CloudWatch / centralized logging)
- CI/CD pipeline for Terraform validation

---

## Author

Tomomasa Sekino  
Enterprise Infrastructure Engineer  
AWS Certified Solutions Architect – Associate