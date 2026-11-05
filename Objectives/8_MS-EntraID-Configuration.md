# Objective brief

The goal for this objective is to set up a proper Entra ID environment and sync it with my on-premise AD.  
I'll be nesting more objectives here than just initial configuration.

# Task 1: Create a MS Azure account and set up the Entra ID environment

I wanted to make use of Microsoft's _Dev Program_ at first, but since I don't qualify, I'll have to make use of the _Free Tenant_.

Free Tenant website: [MS Azure](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account)

After creating the account, I went to the Entra ID admin center and tried a few configurations.

I tried creating a user (lab.admin), a group (IT-Administrators), made _lab.admin_ a member of _IT-Administrators_ etc., just to get the hang of the environment.

## Administrative Accounts

| Account                 | Purpose                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| ZONTCORP\Administrator  | On-premises AD administrative account used during agent installation and gMSA configuration |
| hybrid.admin@zontyy.org | Cloud-only Entra account with Hybrid Identity Administrator role                            |

# Task 2: Sync Entra ID with on-premise AD

My current AD uses a non-public testing domain `ad.zontcorp.test`

I wanted to make use of my own public domain `zontyy.org` as the UPN suffix for user indentities synchronized to Entra ID.

## Domain configuration

First, I added `zontyy.org` as an alternative UPN suffix in Active Directory Domains and Trusts

This allows AD users to use UPNs like `<user>@zontyy.org` for logging in.

Next, I added `zontyy.org` to MS Entra ID and verified domain ownership by creating the required DNS TXT record with my domain registrar.

## Provisioning agent installation

Before creating the cloud sync configuration, I created a new user in Entra ID called `Hybrid Admin` and made him a member of a directory role `Hybrid Identity Administrator`.

Then I downloaded the **on-premises agent** to **DC01**. I went through the installation wizard and successfuly installed the agent to my server.

After installation I verified that I can see the agent in Entra ID admin center under:  
`Entra Connect -> Cloud Sync -> Agents`

## Synchronization configuration

I created a new **AD to Microsoft Entra ID** synchronization configuration.  
Since my homelab is tiny, I only configured the synch scope to only sync _Employees_ OU for now.

I enabled the synchronization, refeshed **Users** tab and all users from my Windows Server were correctly synced with Entra ID.

# Task 3: Password Hash Synchronization validation

I know I have PHS enabled, but I need to test it to be sure, and being able to continue with this project.

## Resetting Jan Novak's password

First, I reset Jan Novak's password on _DC01_.  
After doing that, I'll need to wait a few minutes for the sync to take effect.

## Verifying the sync was successful

After waiting, I opened an incognito Edge window, and tried logging in to MS365.  
Email: `jnovak@zontyy.org`  
Password: _newly created one_

Result: **Login successful**

# Troubleshooting

## Provisioning test

During initial configuration, I misunderstood how OU scoping and Distinguished Names work.

Initially, I entered only Employees as the OU identifier. However, Active Directory identifies directory objects using their full Distinguished Names (DNs).  
The correct DN for my Employees OU is:  
`OU=Employees,DC=ad,DC=zontcorp,DC=test`

I also initially attempted to provision Jan Novak using his username and UPN. The provisioning test couldn't resolve the object until I supplied its full DN:  
`CN=Jan Novak,OU=Employees,DC=ad,DC=zontcorp,DC=test`

The subsequent on-demand provisioning attempt returned:  
`No change summary event was emitted for the call to Provision On-Demand.`

Initially, I interpreted this as another provisioning failure. However, after enabling the synchronization configuration, the users appeared successfully in Entra ID.  
The message itself did not conclusively establish whether provisioning had succeeded; the successful synchronization and resulting user objects provided the confirmation.

# Validation and Testing

| Test                                             | Result                                  |
| ------------------------------------------------ | --------------------------------------- |
| Provisioning agent registration                  | Successful                              |
| Agent service status                             | Running                                 |
| OU-based synchronization scope                   | Configured                              |
| AD user provisioning                             | Successful                              |
| Custom UPN suffix synchronization                | Successful                              |
| Cloud authentication using synchronized identity | Successful                              |
| Password Hash Sychronization                     | Enabled; functional validation verified |
