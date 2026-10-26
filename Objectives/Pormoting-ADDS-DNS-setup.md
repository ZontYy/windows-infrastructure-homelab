# Objective brief

In this objective I want to start by promoting the Windows Server to the AD DC role and then setting up DNS.  
Since I installed Windows Server with GUI, I'll utilize it for the instal of the AD DS. Later I'll also learn to work with Windows Server Core.

# 1. Install AD DS

I'll start by installing the AD DS, then promote it to the DC role in the next step.

## Steps to install

**GUI version:**

1. Open **Server Manager**
2. Select **Manage -> Add Roles and Features**
3. Choose **Role-based or feature-based installation**
4. Select `DC01`
5. Check **Active Directory Domain Services**
6. Click **Add Features** (when prompted)
7. Continue through the wizard..

**PowerShell command to install AD DS:**

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

For this lab I went with the PowerShell route.

# 2. Promoting DC01 to a domain controller

## 2.1. Prepare DNS

First step is to change/set the DNS address of the `DC01` to its own IPv4 address.  
Easiest here would be through the GUI, but I'll try to use CLI commands as much as possible, so the command is:

```powershell
Set-DnsClientServerAddress `
  -InterfaceAlias "Ethernet0" `
  -ServerAddresses 192.168.40.250
```

## 2.2. Create the forest

Domain name I'll be using for this lab is: `ad.zontcorp.test`. I might later change it to my owned real domain, but for learning purposes I'll go with this testing one for now.

**PowerShell command:**

```powershell
Install-ADDSForest `
  -DomainName "ad.zontcorp.test" `
  -DomainNetbiosName "ZONTCORP" `
  -InstallDNS
```

Got an error here, saying that the promotion failed because the **Administrator** account doesn't have a password.  
To fix it, I'll just run this command: `net user Administrator *`  
It will prompt me for a password.  
After creating the password, I was able to successfuly run the command above.

# 3. Verify the result

I'll need to reboot the `DC01` server and then I'll sign in to the domain administrator account => `ZONTCORP\Administrator` using the same password I chose before.

**Verification commands:**

```powershell
Get-ADDomain
Get-ADForest
Get-Service DNS, NTDS, Netlogon, KDC
```

# 4. Verify DNS resolution

```powershell
nslookup DC01.ad.zontcorp.test
nslookup -type=SRV _ldap._tcp.dc._msdcs.ad.zontcorp.test
```

First command should resolve `DC01` to `192.168.40.250`. The 2nd command check the DNS service records that AD clients use to locate a domain controller.  
Both were successful.

# 5. Configure external DNS forwarding

For this lab I'll be choosing Google's public DNS as a forwarder.  
**PowerShell command:**

```powershell
Add-DnsServerForwarder -IPAddress 8.8.8.8, 8.8.4.4
```

**Testing:**

```powershell
Get-DnsServerForwarder
```

I am able to see the configured forwarder here.

```powershell
nslookup google.com
```

I got a successful reply.

# 6. Joining the CLIENT01 to the domain

First I'll need to configure the DNS on the client to the `DC01` IP address. I'll use GUI to do that.

## 6.1. Verify domain-controller discovery

On `CLIENT01` I'll run:

```powershell
nslookup -type=SRV _ldap._tcp.dc._msdcs.ad.zontcorp.test
```

Then:

```powershell
nltest /dsgetdc:ad.zontcorp.test
```

This command asks Windows to locate a domain controller for the domain
Both commands succeeded.

## 6.2. Join the domain

Since both checks succeeded, I can join the domain now:

1. Open **Settings -> System -> About**
2. Select **Domain or workgroup**
3. Under **Computer Name** tab click **Change...**
4. Under **Member of** select **Domain** and enter `ad.zontcorp.test`
5. Enter the domain credentials (for example the Admin account)
6. Restart

After rebooting I'm now able to log in using the **Other user** option and using the `ZONTCORP\Administrator` credentials.  
Since I was able to successfuly join and log into the domain account, I call this a success.

# Outcome

In this objective I was able to install AD DS and promote the `DC01` to domain controller. I was then able to successfuly create the forest, ran all the necessary checks, and ultimately was able to join a Windows Client `CLIENT01` to the domain.
