# Use the Windows Server Core base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set metadata for an image
LABEL maintainer="Your Name <your.email@example.com>"

# Create a new user
RUN net user /add Andreslon

# Set the password for the user
RUN net user Andreslon !QAZ2wsx

# Add the user to the "Remote Desktop Users" group
RUN net localgroup "Remote Desktop Users" Andreslon /add

# Add the user to the "Administrators" group
RUN net localgroup "Administrators" Andreslon /add

# Enable RDP on port 8080
RUN reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d 8080 /f

# Expose port 8080 for RDP
EXPOSE 8080

# Start the command shell in the container
CMD ["cmd"]
