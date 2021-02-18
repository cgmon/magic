#!/usr/bin/env pwsh

# (IMPORTANT! Make sure docker-desktop daemon is running on background)

# Variables

$ROOT_PWD=$(get-location).Path
$APP_REPO='https://github.com/devonfw/my-thai-star.git'
$APP_FOLDER_NAME='app'
$APP_DEV_SERVICE='angular'
$APP_DOCKER_COMPOSE_DEFAULT_FILENAME= 'docker-compose.yml'
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
		
#Create mount folders

ForEach ($Folder in $Folders)
    {
        mkdir -p ./volumes/$Folder
	wsl chown $FoldersPermissions[$Folders.IndexOf($Folder)] ./volumes/$Folder
    }

# increase max map count for sonar

powershell wsl -d docker-desktop "sysctl -w vm.max_map_count=262144"

# mv jenkins jobs

mv ./jenkins/jobs/ ./volumes/jenkins/jenkins_home/


#Prevent bug in vscode remote https://github.com/microsoft/vscode-remote-release/issues/4449

#docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}"|findstr "test_myservice") --force


# git clone app repo

git clone $APP_REPO $APP_FOLDER_NAME

# Add devcontainer, Jenkinsfile and post-commit files

mv ./.devcontainer ./${APP_FOLDER_NAME}/
mv ./post-commit ./${APP_FOLDER_NAME}/.git/hooks/
mv ./jenkins/Jenkinsfile ./${APP_FOLDER_NAME}/${APP_DEV_SERVICE}

# Launch VSCode server remote


$PWD=$(get-location).Path+'\'+${APP_FOLDER_NAME}
$p = $PWD.ToCharArray() | %{$h=''}{$h += ('{0:x}' -f [int]$_)}{$h}
code --folder-uri "vscode-remote://dev-container+$p/"


