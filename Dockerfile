FROM microsoft/windowsservercore

# Add user and set password
RUN net user /add Andreslon
RUN net user Andreslon !QAZ2wsx

# Add user to Remote Desktop Users and Administrators groups
RUN net localgroup "Remote Desktop Users" Andreslon /add
RUN net localgroup "Administrators" Andreslon /add

# Enable RDP and set listening port to 8080
RUN cmd /k reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0
RUN cmd /k reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 8080

# Expose port 8080
EXPOSE 8080

# Start RDP service
CMD ["C:\\Windows\\System32\\svchost.exe", "-k", "RDPService"]
