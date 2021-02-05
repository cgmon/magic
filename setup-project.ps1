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

# (Make sure docker daemon is running on background)

# Variables
$ROOT_PWD=$(get-location).Path
$APP_REPO='https://github.com/devonfw/my-thai-star.git'
$APP_FOLDER_NAME='app'
$APP_DEV_SERVICE='angular'
$APP_DOCKER_COMPOSE_DEFAULT_FILENAME= 'docker-compose.yml'
$IP=(Test-Connection $env:COMPUTERNAME -Count 1).IPV4Address.IPAddressToString
$Folders = 'jenkins/jenkins_home',
            'sonarqube/conf',
            'sonarqube/data',
            'sonarqube/extensions',
            'sonarqube/lib/bundled-plugins',
            'sonarqube-db/data'

$FoldersPermissions = '1000:1000',
		      '999:999',
		      '999:999',
		      '999:999',
		      '999:999',
		      '999'
		
$devjson = @{
	'extensions'= @('devonfw.devonfw-extension-pack')
	'settings' = @{'terminal.integrated.shell.linux'= '/bin/bash'}
	'dockerComposeFile' = @("../$APP_DOCKER_COMPOSE_DEFAULT_FILENAME","docker-compose.yml")
	'workspaceFolder' = "/workspace"
	'service'= "$APP_DEV_SERVICE"
}

$dockercomposeyml= "version: '3'
services:
  ${APP_DEV_SERVICE}:
    volumes:
      - .:/workspace:cached
    command: /bin/sh -c `"while sleep 1000; do :; done`"
"
#mkdir -p ./.devcontainer

#$dockercomposeyml | Out-File -FilePath ./.devcontainer/docker-compose.yml

#$devjson | ConvertTo-Json -Compress | Out-File -FilePath ./.devcontainer/devcontainer.json

#Create mount folders

ForEach ($Folder in $Folders)
    {
        mkdir -p ./volumes/$Folder
	wsl chown $FoldersPermissions[$Folders.IndexOf($Folder)] ./volumes/$Folder
    }

#Update with host's IP docker-compose-copy.yml

#ls -recurse -Include docker-compose.yml | % {sp $_ isreadonly $false; (Get-Content $_) -replace "IP_ADDRESS","$IP" | Set-Content -Path ./docker-compose.refined.yml}

# Add current user to docker- groups

#$user=[System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#net localgroup docker-users $user /add



# increase max map count

powershell wsl -d docker-desktop "sysctl -w vm.max_map_count=262144"

# mv jenkins jobs

mv ./jenkins/jobs/ ./volumes/jenkins/jenkins_home/

#Docker compose up sonar, sonar-db, jenkins 
docker-compose -f docker-compose.yml up -d --build

# git clone repo

git clone $APP_REPO $APP_FOLDER_NAME

# Add devcontainer and post-commit files

mv ./.devcontainer ./${APP_FOLDER_NAME}/
mv ./post-commit ./${APP_FOLDER_NAME}/.git/hooks/

cd ./${APP_FOLDER_NAME}
$PWD=$(get-location).Path
$p = $PWD.ToCharArray() | %{$h=''}{$h += ('{0:x}' -f [int]$_)}{$h}
code --folder-uri "vscode-remote://dev-container+$p/"


