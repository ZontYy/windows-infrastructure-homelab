# Objective brief

Main goal for this objective is implementing a working domain password policy and account lockout policy.

# Planned configuration

| Setting                     | Value             |
| --------------------------- | ----------------- |
| Minimum password length     | 12 characters     |
| Password complexity         | Enabled           |
| Account lockout threshold   | 5 invalid attemps |
| Account lockout duration    | 15 minutes        |
| Reset lockout counter after | 15 minutes        |

These are just **lab** values, not universal security recommendations. This objective is focused on proving I can configure these settings, not prove my skills in properly securing an end device.

# 1. Inspect and document currect values

In the first step I'll inspect and document current values.  
I can view the current values by simply opening a `gpmc.msc`, clicking the `Default Domain Policy` and selecting the **Settings** tab. Then I'll just expand **Security Settings** tab and checking the `Password Policy` and `Account Lockout Policy`

Or I can go the PowerShell route and run the command:

```powershell
Get-ADDefaultDomainPasswordPolicy
```

## Default values

| Setting                     | Value        |
| --------------------------- | ------------ |
| Minimum password length     | 7 characters |
| Password complexity         | Enabled      |
| Account lockout threshold   | 0 (disabled) |
| Account lockout duration    | 10 minutes   |
| Reset lockout counter after | 10 minutes   |

These settings are being served by the `Default Domain Policy` GPO.

# 2. Creating the new GPO

I've verified the current values and verified the source. Now that I know the default values, I can go ahead and create a new seperate GPO that will handle these **Security Policies** on top of the current default GPO.

Right click the root domain `ad.zontcorp.test` and click `Create a GPO in this domain, and Link it here...`

## 2.1. Configuring the GPO

To configure the scope of this GPO, right click the GPO and select `Edit...`  
Navigate to `Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Account Policies`  
There I'll edit the `Password Policy` and `Account Lockout Policy` with the desired values.

| Setting                     | Value             |
| --------------------------- | ----------------- |
| Minimum password length     | 12 characters     |
| Password complexity         | Enabled           |
| Minimum password age        | 1 day             |
| Maximum password age        | 90 days           |
| Password history            | 24 days           |
| Account lockout threshold   | 5 invalid attemps |
| Account lockout duration    | 15 minutes        |
| Reset lockout counter after | 15 minutes        |

## 2.2. Changing the link order and verifying

After successfuly creating and configuring the GPO I checked the supplied values on `DC01` again by running the command:

```powershell
Get-ADDefaultDomainPasswordPolicy
```

And the result was still the same as before configuring my custom GPO.  
So then I check the **Link Order** of the Linked GPOs and found out that the `Default Domain Policy` has higher link order. To change it, open `gpmc.msc` and select the root domain `ad.zontcorp.test` and then open the **Linked Group Policy Objects**. There just select the `GPO-Domain-Password` and move it to the top.

Now, running the command

```powershell
gpupdate /force
```

and then

```powershell
Get-ADDefaultDomainPasswordPolicy
```

Gave me my desired result.

# 3. Testing with an actual user

For this test I'll choose a user that I created during earlier objectives and that I don't actively use.  
For example `Kamil Svoboda`

## 3.1. Password length

![Short password](/screenshots/Password-policies-obj/ksvoboda-short-password.jpg)

## 3.2. Account lockout

![Account Lockout](/screenshots/Password-policies-obj/ksvoboda-lockout.jpg)
![Account Lockout](/screenshots/Password-policies-obj/ksvoboda-lockout2.jpg)

## 3.3. Verifying from an administrative account

On an admin account run:

```powershell
Get-ADUser "ksvoboda" -Properties LockedOut |
    Select-Object SamAccountName, Enabled, LockedOut
```

![verification](/screenshots/Password-policies-obj/ksvoboda-lockout-verify.jpg)

Then try unlocking it:

```powershell
Unlock-ADAccount -Identity "ksvoboda"
```

and run the check again

![unlocked](/screenshots/Password-policies-obj/ksvoboda-unlocked.jpg)

## 3.4. Try logging in

![logged in](/screenshots/Password-policies-obj/ksvoboda-logged-in.jpg)

# Outcome

This objective has taught me how to manage multiple GPOs targetting the same settings and ultimately how to properly set up ordering.  
It also taught me how to configure and enforce password and account lockout policies.  
I've verified every configuration, found and resolved issues (link order) and eventually made it all work.
