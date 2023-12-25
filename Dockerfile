# Base image for Windows Server Core
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Enable RDP
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Expose RDP port 3389 on host port 8080
EXPOSE 8080:3389

# Set a password for the Administrator user
RUN net user Administrator #abCd@1234// /ADD /Y

# Start RDP service
CMD ["C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "Start-Service", "TermService"]
