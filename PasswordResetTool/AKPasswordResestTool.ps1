<######################################
#   AK Password Reset Tool V1.0       #
#    by Allan Kranzusch 12/2016       #
######################################>
Function PasswordGen(){
    $complex=$false
    while ($complex -eq $false)
    {
        $length = get-random -min 8 -max 10
        $passwd=-join ((1..$length)|% {[char](Get-Random -InputObject {33..57;65..90;97..121}.invoke())})
        $complex=($passwd -cmatch '[A-Z]' ) -and  ( $passwd -cmatch '[a-z]' ) -and ( $passwd -imatch '[0-9]' ) -and ( $passwd -imatch "[^A-Z0-9!`"#$%&'()*,-./]") -and !( $passwd -imatch '(ab|bc|cd|de|ef|fg|gh|hi|i|ij|jk|kl|l|lm|mn|no|o|op|pq|qr|rs|st|tu|uv|vw|wx|xy|yz|01|12|23|34|45|56|67|78|89|0)') -and !($passwd -imatch "(.)\1{1,}") -and !($passwd -imatch "[!`"#$%&'()*,-.+/]{2,}")
    }
    $passwd
}

Function Get-upn($u){
    $u = "*"+$u+"*"
    (Get-ADUser -Filter {name -like $u} -prop * | select Name, samaccountname, Department, DistinguishedName |Out-GridView -OutputMode Single -Title "Password Reset - User Search").samaccountname
    }


 Function ResetAndUnlock()
 {  
 	[cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
    param(
       
        [Parameter(Mandatory=$true)]
        [Alias('accountName')]
        $Identity,

        [Parameter(Mandatory=$true)]
        [String]$Pass
 
        )
    $SecPaswd = (ConvertTo-SecureString -String $Pass -AsPlainText -Force)
    Set-ADAccountPassword -Reset -NewPassword $SecPaswd -Identity $Identity -PassThru -Confirm:$false -WhatIf:$false -ErrorAction Stop
    if($?){
    	Set-ADUser -ChangePasswordAtLogon $true -Identity $Identity -Confirm:$false -WhatIf:$false -ErrorAction Stop
     	if($?){
     		msg * 'Password reset successfully'
    	}
     }
    Unlock-ADAccount -Identity $Identity -Confirm:$false -WhatIf:$false -ErrorAction Stop
    if($?){
    	msg * 'Useraccount unlocked'
    }
}

Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Text = "AK Password Reset Tool"
$form.Size = New-Object Drawing.Size (370,190)
$form.StartPosition = "CenterScreen"
$form.BackColor = 'black'
$form.ForeColor = 'white'

$passlabel =New-Object System.Windows.Forms.Label
$passlabel.Text = "New Password: "
$passlabel.AutoSize = $True
$passlabel.Location = New-Object System.Drawing.Size(10,21) 

$passText =New-Object System.Windows.Forms.TextBox
$passText.Text = "password"
$passText.AutoSize = $True
$passText.Location = New-Object System.Drawing.Size(120,20) 

$passbtn = New-Object System.Windows.Forms.Button
$passbtn.add_click({$passText.Text=PasswordGen})
$passbtn.Text = "Generate Password"
$passbtn.Location = New-Object System.Drawing.Size(230,20)
$passbtn.AutoSize = $True
$passbtn.BackColor = 'lightgray'
$passbtn.ForeColor = 'black'

$userText =New-Object System.Windows.Forms.TextBox
$userText.Text = "lastname, firstname"
$userText.AutoSize = $True
$userText.Location = New-Object System.Drawing.Size(120,50) 

$userlabel =New-Object System.Windows.Forms.Label
$userlabel.Text = "Find User By Name: "
$userlabel.AutoSize = $True
$userlabel.Location = New-Object System.Drawing.Size(10,51) 

$searchbtn = New-Object System.Windows.Forms.Button
$searchbtn.add_click({$accountText.Text= Get-upn($userText.Text)})
$searchbtn.Text = "Search"
$searchbtn.Location = New-Object System.Drawing.Size(230,50)
$searchbtn.AutoSize = $True
$searchbtn.BackColor = 'lightgray'
$searchbtn.ForeColor = 'black'

$accountText =New-Object System.Windows.Forms.TextBox
$accountText.Text = "username"
$accountText.AutoSize = $True
$accountText.Location = New-Object System.Drawing.Size(120,80) 

$accountlabel =New-Object System.Windows.Forms.Label
$accountlabel.Text = "User Account Name : "
$accountlabel.AutoSize = $True
$accountlabel.Location = New-Object System.Drawing.Size(10,81) 

$resetbtn = New-Object System.Windows.Forms.Button
$resetbtn.add_click({ResetAndUnlock $accountText.Text $passText.Text})
$resetbtn.Text = "Reset Password"
$resetbtn.Location = New-Object System.Drawing.Size(230,80)
$resetbtn.AutoSize = $True
$resetbtn.BackColor = 'lightgray'
$resetbtn.ForeColor = 'black'

$pcText =New-Object System.Windows.Forms.TextBox
$pcText.Text = "ip address"
$pcText.AutoSize = $True
$pcText.Location = New-Object System.Drawing.Size(120,110) 

$pclabel =New-Object System.Windows.Forms.Label
$pclabel.Text = "IP or Computer Name: "
$pclabel.AutoSize = $True
$pclabel.Location = New-Object System.Drawing.Size(10,111) 

$sendbtn = New-Object System.Windows.Forms.Button
$sendbtn.add_click({msg -Server:$pctext.Text * /time:1800 Your new password is: ($passText.Text)})
$sendbtn.Text = "Send to PC"
$sendbtn.Location = New-Object System.Drawing.Size(230,110)
$sendbtn.BackColor = 'lightgray'
$sendbtn.ForeColor = 'black'
$form.Controls.add($passText)
$form.Controls.add($passlabel)
$form.Controls.Add($passbtn)
$form.Controls.add($userText)
$form.Controls.add($userlabel)
$form.Controls.Add($searchbtn)
$form.Controls.add($accountText)
$form.Controls.add($accountlabel)
$form.Controls.Add($resetbtn)
$form.Controls.add($pcText)
$form.Controls.add($pclabel)
$form.Controls.Add($sendbtn)
$drc = $form.ShowDialog()

