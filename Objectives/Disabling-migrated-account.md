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
2. Check that the converted local account doesn't have any critical running services, tasks or scheduled scripts
   1. **On DC01, run:**

      ```powershell
      Get-CimInstance Win32_Service |
        Where-Object { $_.StartName -match 'zontcorp' } |
        Select-Object Name, State, StartMode, StartName
      ```

      - Expected result: Empty
      - Actual result: Empty

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

      - Expected result: Empty
      - Actual result: Empty

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

      - Expected result: Empty
      - Actual result: Empty

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
