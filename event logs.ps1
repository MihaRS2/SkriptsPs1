# script for monitoring Windows event logs and sending notifications when critical errors are detected

# Path to the log file
$logPath = "C:\Logs\EventLogErrors.log"

# Getting critical errors from the event log
$criticalErrors = Get-EventLog -LogName System -EntryType Error -Newest 100 | Where-Object { $_.EventID -eq 1001 }

if ($criticalErrors) {
    # Saving errors to the log file
    $criticalErrors | Out-File -FilePath $logPath

    # Sending notification to the administrator
    Send-MailMessage -To "admin@domain.com" -From "monitor@domain.com" -Subject "Critical Errors Detected" -Body "Critical errors have been detected in the event log. Please review the attached log file." -Attachments $logPath -SmtpServer "smtp.domain.com"
}

# The script checks the system event log for critical errors and, if such errors are found, saves them to a log file and sends a notification to the administrator with the log file attached.