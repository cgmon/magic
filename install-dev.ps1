#!/usr/bin/env pwsh
# IMPORTANT: Works on Windows 10 Pro/Enterprise (16299+) or Windows 10 Home (18362.1040+)

#Enable wsl options

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

$Packages = 'git',
            'vscode',
            'docker-desktop',
            'wsl2' #docker desktop needs wsl2 linux kernel
 
If(Test-Path -Path "$env:ProgramData\Chocolatey") {
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
}
Else {
  # Install choco
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
  # Install each of desired packages
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
}

# Install vscode remote container extension

code --install-extension ms-vscode-remote.remote-containers

Restart-Computer


