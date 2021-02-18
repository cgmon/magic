# Abracadabra (Capgemini DevOps Challenge)
<img src="https://raw.githubusercontent.com/cgmon/magic/master/magic.png" alt="magic" width="150">


# Jump to content

- [Installation steps](#Installation-steps)
- [Demo](#Demo)
- [Caveats](#Caveats)


# What is this about?

> Abracadabra or magic besides being an incantation used as a magic word and belived to have healing powers, is a Capgemini DevOps challenge solution consisting of a wonderful set of one-click-install artifacts for having a full-fledged Win10-based CICD  DevOps environment suited for industry adoption.


# Installation steps

## System requirements

- Local or Virtual Machine with at least `8GB of RAM`, `20GB of free disk space` and `Windows 10 Pro/Enterprise (16299+) or Windows 10 Home (18362.1040+)`

- `Powershell version => 5` console with `admin rights`

## Steps

- Open the Powershell console as admin <br>
`WIN key + X` and select `Windows Powershell (Admin)`

- Copy and `conjure up` the following spell-ish:

```ps
mkdir magic; wget (Invoke-RestMethod -uri  https://api.github.com/repos/cgmon/magic/releases/latest | select -expand tarball_url) -o t.tar.gz | tar -xf t.tar.gz -C magic --strip-components 1; cd magic; .\install-dev.ps1
```
This will install on your system all required packages and **restart your computer** afterwards.

# Demo

## Initial assumptions

- [My Thai Star App](https://github.com/devonfw/my-thai-star) is the default testing application and the development is front-end oriented
- In order to demonstrate CICD Jenkins capabilities one pipeline job is created: [a scripted pipeline](https://github.com/cgmon/magic/blob/master/jenkins/jobs/magic/config.xml) which goes all through the project's compilation and testing stages and ends up by running a docker container of the project's image.
- A Docker desktop instance is running on the backgroung
## Steps

- Navigate to the root `magic` folder and execute `setup-project.ps1` script

```sh
cd .\magic\
.\setup-project.ps1
```

- A VSCode IDE with fully remote setup will be prompted. If you navigate to the `workspace` folder you can check the mounted repo's folder (i.e. MTS app).

![vscode image](https://raw.githubusercontent.com/cgmon/magic/master/vscode.png)

- Spawn a new shell console by clicking on the `(+)` and cd to the `workspace folder`

```sh
cd ./workspace
```

- Checkout on a new `deploy` branch

```sh
git checkout -b deploy
```

- You can now start your developing. Port `4200` is forwarded by default so if you want to `ng start` your angular project it will be forwarded to your `localhost:4200` (don't forget to run first `npm i`). 

- Commit your changes to trigger the Jenkins jobs, Sonarqube analysis and docker deployment of your image.

```sh
git add .
git commit -m "test"
```

- You can check the current Jenkins job running on the background by navigating to `localhost:8000/job/magic` or simply have your hope in the conjuration.

- Upon successful completion you will be able to access the MTS app at `localhost:7200`

- <h1> <strike>Happy</strike> Wizardly development </h1>

# Caveats

Upon a second execution of the `setup-project` script you may experience problems while VSCode is opening the remote container, like it literally hangs on: `Run: docker-compose ...`, it might be [this issue](https://github.com/microsoft/vscode-remote-release/issues/4449).<br>
 As a workaround, I suggest you to remove the base service's docker image and retry.

```sh
docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}"|findstr "node:14-alpine") --force
```



 
