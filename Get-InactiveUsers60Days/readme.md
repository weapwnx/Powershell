# Get-InactiveUsers60Days

Creates a report of enabled users with an active Office 365 license that haven't appeared to have logged in within the past 60 days by cross-referencing the last logon time attributes between Office 365 and Active Directory. 

Report includes the following fields: 
- Display Name
- Is Licensed (Office 365 license status)
- Enable (Active Directory account enabled status)
- AD Last Logon Date (Last logon date according to Active Directory)
- O365 Last Logon Time (Last logon date according to Office 365)
- Company (Useful for organizations with a lot of contractor accounts)
- Date Created
