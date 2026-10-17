# Windows Infrastructure Homelab

## Overview

A hands-on virtual infrastructure lab designed to develop practical Windows system administration, networking, and cybersecurity skills.

## Objectives

- Deploy and administer Active Directory Domain Services (AD DS).
- Configure DNS and Group Policy.
- Join and manage Windows client machines in a domain.
- Build routed and segmented virtual networks.
- Practice Windows security hardening and troubleshooting.
- Automate administrative tasks using PowerShell.
- Document infrastructure changes, tests, and recovery procedures.

## Lab Environment

| Component | Purpose | Status |
|---|---|---|
| Windows Server | Domain controller and DNS | In progress |
| Windows Client | Domain-joined workstation | In progress |
| VMware Workstation | Virtualization platform | In use |
| Virtual router | Routing, NAT, and firewalling | Planned |

## Repository Structure

- `docs/` — configuration guides, addressing plans, and troubleshooting notes.
- `diagrams/` — network topology and infrastructure diagrams.
- `screenshots/` — sanitized evidence of configurations and test results.

## Security

No passwords, private keys, access tokens, or other sensitive credentials should be committed to this repository.

## Progress

The initial lab consists of a Windows Server VM and a Windows client VM connected through VMware's NAT network (VMnet8).

The next milestone is to deploy Active Directory Domain Services, configure DNS, and join the client to the domain.
