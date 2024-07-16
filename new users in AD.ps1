# Script for bulk creation of new users in Active Directory and adding them to groups
Import-Module ActiveDirectory

# Path to the CSV file with user data
$csvPath = "C:\Users\NewUsers.csv"

# Reading data from the CSV file
$userList = Import-Csv -Path $csvPath

foreach ($user in $userList) {
    # Creating a new user
    New-ADUser -Name $user.Name -GivenName $user.GivenName -Surname $user.Surname -SamAccountName $user.SamAccountName -UserPrincipalName $user.UserPrincipalName -Path $user.Path -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) -Enabled $true

    # Adding the user to groups
    foreach ($group in $user.Groups -split ",") {
        Add-ADGroupMember -Identity $group -Members $user.SamAccountName
    }
}

# This script reads data from a CSV file containing information about new users. For each user, it creates an account and adds the user to specified groups.