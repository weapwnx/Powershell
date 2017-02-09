# AK Password Reset Tool
Active Directory account lockout and password reset tool with password generator.

## Features:
+ Password Generator
	- Random password length between 8 and 10 characters.
  - Passwords all have at least one uppercase letter, lowercase letter, number, and special character.
  - The letters 'i','l','o'and the number 0 have been excluded from passwords to avoid confusion.
  - No consecutive repeating or sequential characters.
+ User Search
  - Find username by "lastname, firstname","firstname", or "lastname".
  - Then select a user from search results.
  - Results include Distinguished Name to aid in differentiating between users who have the same name.
  - Fills account name field automatically.
+ Unlock Account and Reset Password
  - Clicking the "Password Reset" button will unlock the selected user's account, resets their password to whatever is in the password field, and prompts the user to change their password upon logging in.
+ Push New Password to User
	- Send a pop-up message to the user containing their new password by ip address or DNS name.
	
## Use
Save both the .ps1 and .bat files to the same folder. Double-click the .bat file to run the tool. The .bat file creates an one time powershell session that has an script execution policy set to bypass to allow the script to run and loads without a profile to avoid potenial conflicts.
