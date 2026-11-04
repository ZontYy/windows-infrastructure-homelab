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
Get-NetFirewallProfile -PolicyStore ActiveStore |
    Format-Table Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

- Expected result: All profiles should show:  
  | Enabled | DefaultInboundAction | DefaultOutboundAction |
  | --------| -------------------- | --------------------- |
  | True | Block | Allow |
- Actual result:  
  ![Firewall verification](/screenshots/Firewall-via-GPOs/Firewall-enforce-verification.jpg?raw=true)

## 4. Firewall Logging

Navigate to `Computer Configuration\Policies\Windows Settings\Security Settings\Windows Defender Firewall with Advanced Security`  
Open the properties, select the **Domain Profile** tab and locate the logging section.
Configure it as:
| Setting | Value |
| ----- | -----|
| Log dropped packets | Yes |
| Log successful connections | No |
| Log file path | Default |
| Size limit | Default for now |

**Why these settings?**

- **Dropped packets: Yes** - records packets dropped by Windows Defender Firewall. Useful when troubleshooting connectivity and investigating suspicious traffic.
- **Successful connections: No** - avoid generating unnecessary log entries. Possible to enable later for more detailed traffic analysis.

## 5. Apply and verify

Apply all changes on **DC01** and verify on **CLIENT01**.  
On **CLIENT01** refresh the current computer policy:  
`gpupdate /target:computer /force`

Then verify the effective logging configurations:

```powershell
Get-NetFirewallProfile -PolicyStore ActiveStore |
    Select-Object Name, LogFileName, LogMaxSizeKilobytes,
                  LogBlocked, LogAllowed
```

- Expected result: Domain Profile LogBlocked = True, LogAllowed = False
- Actual result:  
  ![Logging result](/screenshots/Firewall-via-GPOs/Logging-result.jpg?raw=true)

## 6. Generate a controlled firewall event
