#!/bin/bash
userServiceDirectory() {
	echo "$URSIM_ROOT/service"
}

userDaemonManagerDirectory() {
	echo "/etc/runit/runsvdir-ursim-$VERSION"
}

installDaemonManager() {
	local userServiceDirectory=`userServiceDirectory`
	local userDaemonManagerDirectory=`userDaemonManagerDirectory`
	local userDaemonManagerRunScript="$userDaemonManagerDirectory/run"

	echo "Installing daemon manager package"
	sudo apt-get -y install runit

	echo "Creating user daemon service directory"
	sudo mkdir -p $userDaemonManagerDirectory
	echo '#!/bin/sh' | sudo tee $userDaemonManagerRunScript >/dev/null
	echo 'exec 2>&1' | sudo tee -a $userDaemonManagerRunScript >/dev/null
	echo "exec chpst -u`whoami` runsvdir $userServiceDirectory" | sudo tee -a $userDaemonManagerRunScript >/dev/null
	sudo chmod +x $userDaemonManagerRunScript

	echo "Starting user daemon service"
	sudo ln -sf $userDaemonManagerDirectory /etc/service/
	mkdir -p $userServiceDirectory
}



# if we are not running inside a terminal, make sure that we do
tty -s
if [[ $? -ne 0 ]]
then
	xterm -e "$0"
	exit 0
fi

set -e

commonDependencies='libcurl3 openjdk-8-jre libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai'
if [[ $(getconf LONG_BIT) == "32" ]]
then
	packages=`ls $PWD/ursim-dependencies/*i386.deb`
	pkexec bash -c "apt-get -y install $commonDependencies && (echo '$packages' | xargs dpkg -i)"
else
	packages=`ls $PWD/ursim-dependencies/*amd64.deb`
	pkexec bash -c "apt-get -y install lib32gcc1 lib32stdc++6 libc6-i386 $commonDependencies && (echo '$packages' | xargs dpkg -i)"
fi

versionString=`java -version 2>&1 | head -n1 | grep 1\.6\.0`
if [[ -z $versionString ]]
then
        echo "Please select Java version 1.6 using update-alternatives"
        return
fi

source version.sh
URSIM_ROOT=$(dirname $(readlink -f $0))

echo "Install Daemon Manager"
installDaemonManager

for TYPE in UR3 UR5 UR10
do
	FILE=$HOME/Desktop/ursim-$VERSION.$TYPE.desktop
	echo "[Desktop Entry]" > $FILE
	echo "Version=$VERSION" >> $FILE
	echo "Type=Application" >> $FILE
	echo "Terminal=false" >> $FILE
	echo "Name=ursim-$VERSION $TYPE" >> $FILE
	echo "Exec=${URSIM_ROOT}/start-ursim.sh $TYPE" >> $FILE
	echo "Icon=${URSIM_ROOT}/UR_Logo_24x24.png" >> $FILE
	chmod +x $FILE
done

pushd $URSIM_ROOT/lib &>/dev/null
chmod +x ../URControl

popd &>/dev/null
