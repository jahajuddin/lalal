# Use the official Windows Server Core image as the base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set environment variables
ENV USERNAME admin1337
ENV PASSWORD #abCd@1337//
ENV PORT 8080

# Install chocolatey for package management
RUN powershell -Command Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install the required software
RUN choco install -y git openssh-server

# Configure SSH server
RUN powershell -Command New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force; \
    powershell -Command Start-Service sshd; \
    powershell -Command Set-Service -Name sshd -StartupType 'Automatic'

# Expose RDP port
EXPOSE $env:PORT

# Enable RDP
RUN powershell -Command \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 1

# Create a script for configuring RDP
RUN echo "net user $env:USERNAME $env:PASSWORD /add" > C:\configure_rdp.ps1; \
    echo "net localgroup administrators $env:USERNAME /add" >> C:\configure_rdp.ps1; \
    echo "reg add \"HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" /v fSingleSessionPerUser /t REG_DWORD /d 0 /f" >> C:\configure_rdp.ps1; \
    echo "reg add \"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\" /v AllowRemoteRPC /t REG_DWORD /d 1 /f" >> C:\configure_rdp.ps1; \
    echo "reg add \"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\" /v fAllowToGetHelp /t REG_DWORD /d 1 /f" >> C:\configure_rdp.ps1

# Run the configuration script
RUN powershell -Command C:\configure_rdp.ps1

# Clean up
RUN del C:\configure_rdp.ps1

# Start the SSH and RDP services
CMD ["powershell", "Start-Service sshd ; Start-Service TermService ; cmd /c netstat -an | find \"LISTENING\""]
