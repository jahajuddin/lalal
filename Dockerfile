# Use the official Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Create a user and add to groups
RUN net user /add Andreslon
RUN net user Andreslon !QAZ2wsx
RUN net localgroup "Remote Desktop Users" Andreslon /add
RUN net localgroup "Administrators" Andreslon /add

# Enable Remote Desktop and set port to 8080
RUN reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
RUN reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 8080 /f

# Expose port 8080 for RDP
EXPOSE 8080

# Start the RDP service
CMD ["cmd.exe", "/C", "start", "C:\\Windows\\System32\\cmd.exe", "/K", "c:\\windows\\system32\\svchost.exe", "-k", "termsvcs"]
