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

| Component          | Purpose                       | Status  |
| ------------------ | ----------------------------- | ------- |
| VMware Workstation | Virtualization platform       | In use  |
| Windows Server     | Domain controller and DNS     | In use  |
| Windows Client     | Domain-joined workstation     | In use  |
| Linux Server       | Domain-joined NAS             | Planned |
| Virtual router     | Routing, NAT, and firewalling | Planned |

## Repository Structure

- `docs/` — configuration guides, addressing plans, and troubleshooting notes.
- `diagrams/` — network topology and infrastructure diagrams.
- `screenshots/` — sanitized evidence of configurations and test results.
- `objectives/` — tasks finished, in progress etc. Learning paths, verification, troubleshooting, the whole process

## Security

No passwords, private keys, access tokens, or other sensitive credentials should be committed to this repository.

## Progress

The initial lab consists of a Windows Server VM and a Windows client VM connected through VMware's NAT network (VMnet8).

### AD DC Promotion

Promoted DC01 to the AD DS role and set up a DNS server with a domain name `ad.zontcorp.test`

### Shared folder objective

Next, I created a shared folder along with a Security Group, then I applied NTFS permissions for the group and also Share permissions. Then I verified the accessibility.

### Unnecessary privileged account disabling

As my next objective I picked a security-oritented one. My local account `zontcorp` has most likely been automatically been converted to a Active Domain account when promoting.  
Since this brings another unnecessary privileged account (built-in Administrator) I decided to disable it.

### GPO creation and management

Next, I wanted to create a GPO (Group Policy Object). I created one called `GPO-Workstation-Baseline` which will enforce baseline policies for all workstations on the domain.  
As of right now, it only enforces an _Interactive Logon_ policy for _Title_ and _Text_ when trying to log in.

### Firewall managed by GPO

Another objective was to edit the GPO to also manage Firewall rules. I managed to do just that, verified everything works and documented it.  
Next step was to enable logging, which also went smooth ON PAPER. For some reason I was unable to make the firewall service write to the logging file in my testing phase.  
I tried basic connectivity test to an unused port, I tried adding a firewall rule for that specific port to block all traffic, but nothing seemed to help adding an entry to the log file.  
I'll be getting back to this topic later.
