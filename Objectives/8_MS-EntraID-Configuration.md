# Objective brief

The goal for this objective is to set up a proper Entra ID environment and sync it with my on-premise AD.  
I'll be nesting more objectives here than just initial configuration.

# Task 1: Create a MS Azure account and set up the Entra ID environment

I wanted to make use of Microsoft's _Dev Program_ at first, but since I don't qualify, I'll have to make use of the _Free Tenant_.  
Free Tenant website: [MS Azure](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account)  
After creating the account, I went to the Entra ID admin center and tried a few configurations.  
I tried creating a user (lab.admin), a group (IT-Administrators), made _lab.admin_ a member of _IT-Administrators_ etc., just to get the hang of the environment.

| Account                 | Purpose                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------- |
| ZONTCORP\Administrator  | On-premises AD administrative account used during agent installation and gMSA configuration |
| hybrid.admin@zontyy.org | Cloud-only Entra account with Hybrid Identity Administrator role                            |

# Task 2: Sync Entra ID with on-premise AD

My current AD uses a non-public testing domain `ad.zontcorp.test` and for this I wanted to make use of my own public domain `zontyy.org`. So I first added the domain to my AD's UPN suffixes and also verified it in Entra ID.  
Then, before creating the cloud sync configuration, I created a new user in Entra ID called `Hybrid Admin` and made him a member of a directory role `Hybrid Identity Administrator`. This user will be used for the sync agent.
Next, I downloaded the **on-premises agent** to **DC01**. I went through the installation wizard and successfuly installed the agent to my server. I then verified that I can see the agent in Entra ID admin center at `Entra Connect -> Cloud Sync -> Agents`.
Then I created the actual synchronization. Since my homelab is tiny, I only configured the synch scope to only sync _Employees_ OU for now.  
I enabled the synchronization, refeshed **Users** tab and all users from my Windows Server were correctly synced with Entra ID.

# Troubleshooting

## Provisioning test

Since this was my first time working with Entra and AD, I didn't quite understand what a **DN** stands for, so when configuring the **Scope Filtering** I simply put in `Employees`, thinking that that's enough. Well, I quickly learned it wasn't and that a DN means the exact path and position within the AD. So for my _Employees_ OU it's actually: `OU=Employees,DC=ad,DC=zontcorp,DC=test`.  
Same goes for user. When I tested the sync without actually enabling it yet, I had the filter set to **Employees** and tried on-demand provisioning of the user **Jan Novak**. That didn't work. So I did some research and found out what DN actually means, tried that and got a message saying something like _no changes were found..._.  
At first I thought that I did something wrong again or my sync doesn't work properly, so I googled the message and found out that it just means that the agent haven't found any changes to be synced for the chosen object. That confirmed to me that it works and I enabled the sync.  
It synchronized successfully.
