# Objective brief

The goal is to automate access to network shares using AD groups and GPO just as in a real corporate environment.

# Target architecture

| Component            | Configuration                                |
| -------------------- | -------------------------------------------- |
| File Server          | `DC01.ad.zontcorp.test`                      |
| Existing Share       | `\\DC01\FinanceReports`                      |
| Security Group       | `Finance-Reports-Read`                       |
| Target User          | `ZONTCORP\jnovak`                            |
| Drive Letter         | `F:`                                         |
| Deployment mechanism | Group Policy Preferences                     |
| Access Control       | Existing AD group and NTFS/Share permissions |

**Expected result:** Jan Novak logs into `CLIENT01` and the `FinanceReports` share automatically appears as drive `F:`—without manually mapping it.

# Step 1: Inspect the existing configuration

I'll run these commands to check if everything is ready:

```powershell
Get-ADGroupMember "Finance-Reports-Read" |
    Select-Object Name, SamAccountName, ObjectClass
```

```powershell
Get-SmbShare -Name "FinanceReports" |
    Select-Object Name, Path, Description
```

```powershell
Get-ChildItem "C:\Shared\FinanceReports"
```

These commands check that the security group exists (and members), checks the share and the document itself respectively.

# Step 2: Create the drive-mapping GPO

1. Open **Group Policy Management** (`gpmc.msc`)
2. Expand the `ad.zontcorp.test`
3. Right-click the **Employees** OU
4. Select **Create a GPO in this domain, and Link it here...**
5. Name: `GPO-Drive-Mappings`
6. Ok

# Step 3: Configure the mapped drive

1. Right-click `GPO-Drive-Mapping`
2. Select **Edit**
3. Navigate to: `User Configurations -> Preferences -> Windows Settings -> Drive Maps`
4. Right-click **Drive Maps**
5. Select **New -> Mapped Drive**

## 3.1. Configure the General Tab

| Field        | Value                                    |
| ------------ | ---------------------------------------- |
| Action       | `Update`                                 |
| Location     | `\\DC01.ad.zontcorp.test\FinanceReports` |
| Label as     | `Finance Reports`                        |
| Drive Letter | `F:`                                     |
| Connect as   | Blank                                    |
| Reconnect    | Checked                                  |

![Share listed](/screenshots/Drive-Mapping-GPO/share-listed-as-drive.jpg?raw=true)

# Step 4: Configure security-group targeting

1. Open `gpmc.msc`
2. Edit `GPO-Drive-Mappings`
3. Navigate to: `User Configuration -> Preferences -> Windows Settings -> Drive Maps`
4. Right-click the `F:` mapping for `FinanceReports` and select **Properties**
5. Open the **Common** tab
6. Check **Item-level targeting**
7. Click **Targeting...**

## 4.1. Configure the condition

1. Click **New Item -> Security Group**
2. Select the new **Security Group** condition
3. Configure it as follows:
   - **User:** `ZONTCORP\Finance-Reports-Read`
   - **Property:** `Is`
   - **Action:** `User is a member of the security group`
4. Click **OK** to save the condition
5. Click **OK** again to save the drive mapping properties

## 4.2. Verify the condition

First I'll try to log in as a user that's not in the security group `Finance-Reports-Read`  
![Unauthorized](/screenshots/Drive-Mapping-GPO/ecerna-no-listing.jpg?raw=true)

Then I'll try with Jan Novak who is a part of that security group  
![Authorized](/screenshots/Drive-Mapping-GPO/jnovak-drive-listed.jpg?raw=true)

# Outcome

I was successfuly able to create a share mapping using GPO and then even configured security-group targeting. I then verified my configurations and it was successful. Eva Cerna who is not a part of the security group `Finance-Reports-Read` was not able to see the mapped folder, whilst Jan Novak was because he's part of the group.  
This objective taught me how to deploy SMB shared folders and map them to clients without having to locate them manually and also taught me how to secure it.
