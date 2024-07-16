# Checking for updates
Get-WindowsUpdate -AcceptAll -Install -AutoReboot

# Logging the results
Get-WindowsUpdateLog -LogPath "C:\Logs\WindowsUpdate.log"

# The script uses the PSWindowsUpdate module to check and install all available updates. After installing updates, the system will automatically reboot if necessary.