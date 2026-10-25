# Objective brief

The main focus of this objective will be creating and managing group policies, to learn and understand how it works, why it's necessary and what it does.

# Setup

- GPO Name: GPO-Workstation-Baseline
- GPO Link: ad.zontcorp.test\Workstations
- GPO Settings: Interactive logon (Title and Message)

# Tasks

1. Organize Active Directory with Organizational Units

   I'll be creating this structure:

   ```
   ad.zontcorp.test
         │
         ├─ Employees
         │
         ├─ Workstations
         │  └─ CLIENT01
         └─ Servers (Domain Controllers for now)
            └─ DC01
   ```

**Important:** Don't move `DC01` out of the builtin `Domain Controllers` OU

2. Creating the first GPO

   My first GPO will be named: `GPO-Workstation-Baseline` and it will be linked to the `Workstations` OU  
   It will contain baseline configuration for every domain-joined workstation
   ![GPO created](/screenshots/Creating-GPOs-obj/GPO-created.jpg?raw=true)

3. Configure the GPO

   For testing purposes I'll only add `Interactive Logon: Message Text/Title for users attempting to log on`  
   I'll be adding more policies as I progress, but those will be different objectives

   **Current policies:**
   - Message title: Managed Device
   - Message text: This device is managed by ZONTCORP

4. Verify that the GPO is active and enforced

   To verify, I'll first sign out of the account and try to sign back in
   - Expected result: Managed Device
   - Actual result: Managed Device log on message
     ![Log in message shown](/screenshots/Creating-GPOs-obj/login-msg.jpg?raw=true)

   Then, as an admin I'll run the command:

   ```powershell
   gpresult /r /scope Computer
   ```

   - Expected result: GPO-Workstation-Baseline shown
   - Actual result:

   ```
   RSOP data for on CLIENT01 : Logging Mode

   ---

   OS Configuration: Member Workstation
   OS Version: 10.0.26300
   Site Name: Default-First-Site-Name
   Roaming Profile:
   Local Profile:
   Connected over a slow link?: No

   ## COMPUTER SETTINGS

       CN=CLIENT01,OU=Workstations,DC=ad,DC=zontcorp,DC=test
       Last time Group Policy was applied: 10/25/2026 at 7:34:41 PM
       Group Policy was applied from:      DC01.ad.zontcorp.test
       Group Policy slow link threshold:   500 kbps
       Domain Name:                        ZONTCORP
       Domain Type:                        Windows 2008 or later

       Applied Group Policy Objects
       -----------------------------
           GPO-Workstation-Baseline # GPO IS LISTED HERE
           Default Domain Policy

       The following GPOs were not applied because they were filtered out
       -------------------------------------------------------------------
           Local Group Policy
               Filtering:  Not Applied (Empty)

       The computer is a part of the following security groups
       -------------------------------------------------------
           BUILTIN\Administrators
           Everyone
           BUILTIN\Users
           NT AUTHORITY\NETWORK
           NT AUTHORITY\Authenticated Users
           This Organization
           CLIENT01$
           Domain Computers
           Authentication authority asserted identity
           System Mandatory Level

   ```

   Then last verification command run with elevated privileges:

   ```powershell
   gpresult /h "C:\Users\[current user]\Desktop\gpresult.html"
   ```

   This will create a clean html website which will give every information necessary. **Crucial to run it as admin**, otherwise the GPO won't show because it's managing the whole computer, not just the user

## Outcome

During this objective I learned how to create, link and configure GPOs. I learned the difference between **User Group Policy** and **Computer Group Policy**.  
I also learned why organization into OUs matters.  
In the end, I managed to successfuly create, configure and link/enforce a GPO for my _Workstations_ OU and I've verified that it works.  
I had no issues but one, the command `gpresults /r` only show's "User Group Policies" and not for the whole Computer, so I had to add an argument `/scope Computer` and run the command in a privileged shell to be able to see the group policy I created.
