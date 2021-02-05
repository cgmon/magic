#!/usr/bin/env pwsh

############################################################################
# Copyright 2020 Capgemini SE.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
############################################################################

# IMPORTANT: Works on Windows 10 Pro/Enterprise (16299+) or Windows 10 Home (18362.1040+)

#To run in command promp as admin:  powershell -executionpolicy bypass -File install-dev.ps1 

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


# Fetch magic folder

git clone https://github.com/cgmon/magic.git

# Install vscode remote container extension

code --install-extension ms-vscode-remote.remote-containers

Restart-Computer


