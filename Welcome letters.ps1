Import-Module ActiveDirectory

# Setting up data for Exchange connection
$ExchangeServer = "mail.lureit.ru"

# Setting up data for Exchange connectionЗ
$ExchangeCredential = Import-CliXml -Path "C:\path\to\credentials.xml"

# Function to send a welcome email
function Send-WelcomeEmail {
    param (
        [string]$To,
        [string]$UserName,
        [PSCredential]$Credential
    )

    $From = "mail.lureit.ru"  # Sender's address
    $Subject = "Добро пожаловать в компанию LUREIT!"
    $Body = @"
    Уважаемый $UserName,

    Добро пожаловать в нашу компанию! Мы рады приветствовать вас в нашей команде.
    Немного полезной информации для вас:
    Confluence (WIKI): https://wiki.corp.lureit.ru здесь вы найдете максимум информации которая вам может понадобится.
    Сервер Bitrix24: t-lab-proc.lureit.ru
    Сервер VPN: vpngw2.lureit.ru Логин ваша почта, пароль тот же что вы вводите при включении компьютера
    Nextcloud (Наше облако) https://nc.lureit.ru
    JVCS (Видеоконференц связь) https://vc.lureit.ru
    Обращение в тех.поддержку: Для обращения в тех.поддержку вам нужно написать письмо с проблемой на 911@lureit.ru


    С наилучшими пожеланиями,
    Ваша команда технической поддержки LUREIT
"@

    Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SmtpServer $ExchangeServer -Credential $Credential -UseSsl -Port 587
}

# Getting new users from Active Directory for the last 24 hours
$NewUsers = Get-ADUser -Filter {WhenCreated -ge (Get-Date).AddDays(-1)} -Properties EmailAddress, Name

foreach ($user in $NewUsers) {
    if ($user.EmailAddress) {
        # Sending a welcome email
        Send-WelcomeEmail -To $user.EmailAddress -UserName $user.Name -Credential $ExchangeCredential
    } else {
        Write-Host "User $($user.Name) has no email address."
    }
}

Write-Host "All emails have been sent."
