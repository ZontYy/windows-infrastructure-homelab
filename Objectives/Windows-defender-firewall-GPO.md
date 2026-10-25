# Objective brief

In this objective I'll create a GPO for default firewall settings to be enforced on each domain-joined workstation.

# Steps

## 1. Configuring the GPO

First I find the _GPO-Workstation-Baseline_ GPO in the `gpmc.msc` and right-click then click **Edit...**

There I navigate to `Computer Config\Windows Settings\Security Settings\Windows Defender Firewall with Advanced Secutiry\Windows Defender Firewall with Advanced Security - LDAP:\\...`  
Then I right-click the _LDAP:\\_ module and click on Properties

## 2. Configuring each profile

For **each of the three profiles** (Domain, Private, Public) I'll configure it like this:

| Setting              | Value            |
| -------------------- | ---------------- |
| Firewall state       | On (recommended) |
| Inbound connections  | Block (default)  |
| Outbound connections | Allow (default)  |

**Why these rules?**  
That's simple. I need the firewall to be active no matter the network profile selected and I also need to protect my network from incoming packets, while leaving the outgoing packets unaffected so that clients can communicate with the internet.

- **Firewall On**: Ensures the firewall is active regardless of the network profile
- **Inbound block**: Block unsolicited inbound connections unless an applicable firewall rule permits them
- **Outbound allow**: Lets normal client traffic—DNS queries, web browsing and domain communication initiated by the client—work without requiring a separate outbound rue for every destination

## 3. Apply and verify

After configuring all of the rules, click **Apply** then **OK**  
On _CLIENT01_ open an elevated PowerShell session and run:  
`gpupdate /target:computer /force`

Then check the effective firewall configuration:

```powershell
Get-NetFirewallProfile |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

- Expected result: All profiles should show:  
  | Enabled | DefaultInboundAction | DefaultOutboundAction |
  | --------| -------------------- | --------------------- |
  | True | Block | Allow |
