<######################################
#   Get-InactiveUsers60Days V1.0      #
#    by Allan Kranzusch 1/2017        #
######################################>

Function Set-FileName
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")  | Out-Null
    
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.initialDirectory = "%HOMEDIRECTORY%"
    $SaveFileDialog.filter = "CSV (*.csv)| *.csv"
    $SaveFileDialog.fileName = ('inactive60daysAD-'+ (Get-Date -Format M-d-yyyy))
    $SaveFileDialog.DefaultExt = "csv"
    if ($SaveFileDialog.ShowDialog() -eq  [System.Windows.Forms.DialogResult]::OK)
    {$SaveFileDialog.filename}
}

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MsolService -Credential $UserCredential

$time=((Get-Date).AddDays(-60))

Get-MsolUser -All | Where-Object { $_.isLicensed -eq "TRUE" -and (Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid).enabled -eq "TRUE" -and (Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid -prop *).LastLogonDate -lt $time -and (Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid -prop *).created -lt $time -and (Get-MailboxStatistics $_.UserPrincipalName).LastLogonTime -lt $time } | select DisplayName, isLicensed, @{Name="Enabled";Expression={(Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid).enabled}}, @{Name="ADLastLogonDate";Expression={(Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid -prop *).LastLogonDate}}, @{Name="O365LastLogonTime";Expression={(Get-MailboxStatistics $_.UserPrincipalName).LastLogonTime}}, @{Name="company";Expression={(Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid -prop *).company}}, @{Name="Date Created";Expression={(Get-ADUser -id ([GUID][system.convert]::frombase64string($_.immutableid)).guid -prop *).created}} |Export-Csv (Set-FileName) -NoTypeInformation

Exit-PSSession $Session
