# Script for checking user passwords for compliance with security policy and sending notifications

Import-Module ActiveDirectory

# Path to the CSV file with users
$csvPath = "C:\Users\CheckUsers.csv"

# Reading data from the CSV file
$userList = Import-Csv -Path $csvPath

foreach ($user in $userList) {
    $userAccount = Get-ADUser -Identity $user.SamAccountName -Properties PasswordLastSet, AccountExpirationDate
    $passwordLastSet = $userAccount.PasswordLastSet
    $passwordPolicy = [System.DirectoryServices.AccountManagement.PasswordPolicy]::GetPasswordPolicy($userAccount)

    if ((Get-Date) -gt $passwordLastSet.AddDays($passwordPolicy.MaxPasswordAge.TotalDays)) {
        # Sending notification to the user
        Send-MailMessage -To $user.Email -From "admin@domain.com" -Subject "Password Expiry Notification" -Body "Your password has expired. Please change it as soon as possible." -SmtpServer "smtp.domain.com"
    }
}
# The script checks the last password change date for each user and compares it to the maximum password age policy. If the password is expired, a notification email is sent to the user.