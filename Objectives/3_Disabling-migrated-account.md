# Objective brief

When I installed the AD DS role a local account `zontcorp` from the DC01 server has automatically been converted into the Active Domain account.  
Since this account has elevated privileges and we already have an `Administrator` account for admin stuff, we don't need a 2nd one at this point.

# Steps

1. Verify that the builtin `Administrator` account is accessible on both the DC01 and CLIENT01 and that it can perfrom stuff requiring elevated privileges
   1. **Log into DC01 and run this command as admin:**
      ```powershell
      Get-ADUser -Identity "Administrator" -Properties Enabled, SID |
      Select-Object Name, SamAccountName, Enabled, SID
      ```
   2. **Inspect direct group memberships:**
      ```powershell
      Get-ADPrincipalGroupMembership -Identity "Administrator" |
      Select-Object Name, GroupScope, GroupCategory
      ```
      **Verification:**
      - Account is enabled: Confirmed
      - Login on DC01: Successful
      - Login on CLIENT01: Successful
      - Administrative operations: Verified

2. Check that the converted local account doesn't have any critical running services, tasks or scheduled scripts
   1. **On DC01, run:**

      ```powershell
      Get-CimInstance Win32_Service |
        Where-Object { $_.StartName -match 'zontcorp' } |
        Select-Object Name, State, StartMode, StartName
      ```

      - Expected result: No matching services
      - Actual result: No matching services found

   2. **Check scheduled tasks:**

      ```powershell
      Get-ScheduledTask |
          Where-Object {
              $_.Principal.UserId -match 'zontcorp'
            } |
      Select-Object TaskPath, TaskName,
          @{Name='RunAs'; Expression={$_.Principal.UserId}},
          State
      ```

      - Expected result: No matching scheduled tasks
      - Actual result: No matching scheduled tasks found

   3. **Check currently running processes:**

      ```powershell
      Get-CimInstance Win32_Process |
          ForEach-Object {
              $process = $_

              $owner = Invoke-CimMethod -InputObject $process -MethodName GetOwner `
              -ErrorAction SilentlyContinue

              if ($owner.ReturnValue -eq 0 -and
                  $owner.User -match '^zontcorp$') {
                  [PSCustomObject]@{
                      ProcessId   = $process.ProcessId
                      ProcessName = $process.Name
                      Domain      = $owner.Domain
                      User        = $owner.User
                  }
              }
          }
      ```

      - Expected result: No matching processes
      - Actual result: No matching processes found

3. Review the evidence the account is safe to be disabled
4. Disabling the account
   1. **On DC01 run as admin:**
      ```powershell
      Disable-ADAccount -Identity "zontcorp"
      ```
   2. **Verify the result:**

      ```powershell
      Get-ADUser -Identity "zontcorp" -Properties Enabled |
          Select-Object SamAccountName, Enabled
      ```

      - Expected result: False
      - Actual result: False

5. Verify that the account is really disabled by trying to log into it on `CLIENT01`

   **Attempt to log in to CLIENT01 using ZONTCORP\zontcorp credentials**
   - Expected result: Account has been disabled
   - Actual result: Your account has been disabled. Please see your system administrator.

## Outcome

The `zontcorp` domain account has been disabled successfully. The builtin `Adminstrator` account was verified as an alternative administrative account, and no service, scheduled task, or running process dependencies on `zontcorp` were identified

The account was disabled rather than deleted to preserve its identity and existing security references, allowing it to be re-enabled if needed

## Security rationale

Why was this account disabled?

- Reduce unnecessary privileged accounts
- Apply the principle of least privilege
- Preserve a recovery path by disabling rather than deleting the account
- Verify administrative access before changing account status
