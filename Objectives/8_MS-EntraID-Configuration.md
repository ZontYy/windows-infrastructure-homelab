# Objective brief

The goal for this objective is to set up a proper Entra ID environment and sync it with my on-premise AD.  
I'll be nesting more objectives here than just initial configuration.

# Task 1: Create a MS Azure account and set up the Entra ID environment

I wanted to make use of Microsoft's _Dev Program_ at first, but since I don't qualify, I'll have to make use of the _Free Tenant_.  
Free Tenant website: [MS Azure](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account)  
After creating the account, I went to the Entra ID admin center and tried a few configurations.  
I tried creating a user (lab.admin), a group (IT-Administrators), made _lab.admin_ a member of _IT-Administrators_ etc., just to get the hang of the environment.

# Task 2: Sync Entra ID with on-premise AD

## Domain configuration

My current AD uses a non-public testing domain `ad.zontcorp.test` and for this I wanted to make use of my own public domain `zontyy.org`. So I first added the domain to my AD's UPN suffixes and also verified it in Entra ID. Main reason for this is that my users can now use `<user>@zontyy.org` for logging in, which is much simpler and nicer than `<user>@ad.zontcorp.test`.

## Provisioning agent installation

Before creating the cloud sync configuration, I created a new user in Entra ID called `Hybrid Admin` and made him a member of a directory role `Hybrid Identity Administrator`. This user will be used for the sync agent.  
Next, I downloaded the **on-premises agent** to **DC01**. I went through the installation wizard and successfuly installed the agent to my server. I then verified that I can see the agent in Entra ID admin center at `Entra Connect -> Cloud Sync -> Agents`.

## Synchronization configuration

I created a new **AD to Microsoft Entra ID** synchronization configuration.  
Since my homelab is tiny, I only configured the synch scope to only sync _Employees_ OU for now.  
I enabled the synchronization, refeshed **Users** tab and all users from my Windows Server were correctly synced with Entra ID.

| Account                 | Purpose                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| ZONTCORP\Administrator  | On-premises AD administrative account used during agent installation and gMSA configuration |
| hybrid.admin@zontyy.org | Cloud-only Entra account with Hybrid Identity Administrator role                            |

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
