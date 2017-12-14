## Ursim Installation Guide

This describes how to have ursim running in Ubuntu 16.04. The latest Ursim could be downloaded from [here](https://www.universal-robots.com/download/?option=31153#section16632). Unzip the files using
```tar -zxf filename.tar.gz``` 

## How to Install Ursim (Polyscope Interface - Univeral Robot): 

1. Install [Java 8](https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04).
2. Change the following line, in install.sh file: ( A sample file could be found in the repo) 
    ```commonDependencies='libcurl3 openjdk-6-jre libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai' ```
    to

    ```commonDependencies='libcurl3 openjdk-8-jre libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai' ```
3. Make sure the system is sourcing or using java8. This can be done by: 
    -   Find the version of java that is running or sourced by
        `java -version`
    -   if there are multiple version use: `sudo update-alternatives --config java` 
    -   select the version to be jdk 8.

4. Change the following files to be executable ```sudo chmod +x filename.sh```
    -   start-ursim.sh
    -   starturcontrol.sh
    -   stopurcontrol.sh
    -   URControl
5. Run in the terminal ```bash install.sh``` or ```. install.sh``` from the unzipped folder.
6. Run ```bash start-ursim.sh``` or ```. start-ursim.sh``` from the unzipped file directory system.
