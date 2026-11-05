# User to search for (SAM account name)
$Username = ""

$Computers = Get-ADComputer -Filter 'Enabled -eq $true' |
    Select-Object -ExpandProperty Name

foreach ($Computer in $Computers) {
    try {
        $Sessions = quser /server:$Computer 2>$null

        if ($Sessions -match [regex]::Escape($Username)) {
            Write-Host "`nFound $Username on $Computer" -ForegroundColor Green
            $Sessions | Select-String ([regex]::Escape($Username))
        }
    }
    catch {
        # Computer unavailable or remote session query failed
    }
}