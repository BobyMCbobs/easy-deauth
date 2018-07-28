# easy-deauth

#### Release version: 1.1

##### Description
Send deauth packages to your favourite devices on your private WiFi network!
As this ultimately relies on aircrack-ng, all of the work for this program is in the programs from that package.
easy-deauth just scripts it, to make it more straight forward and easier.
(Previously named deauthAttackMadeEasy)

##### Features  
- Finds network interfaces and best guesses which are wireless.
- Automatic configuration of network interface to work with airmon-ng.

##### Packaging
Debian:  
	Binary: `make deb-pkg`  
	Source: `make deb-src`  
CentOS/Fedora specs: support/specs/CentOS-Fedora  
openSUSE specs: support/specs/openSUSE  
Arch Linux: [AUR](https://aur.archlinux.org/packages/easy-deauth)  
Zip archive: `make build-zip`  

##### Installation
Non-package installation: `make install`  

##### Dependencies  
Ubuntu/Debian/Raspbian: net-tools aircrack-ng  
Arch Linux: net-tools aircrack-ng  
Fedora/CentOS: net-tools aircrack-ng(? on CentOS)  
openSUSE: net-tools aircrack-ng(?)  

##### Usage
Standard use: `getnewip`  
Help: `getnewip -h`  

##### Notes
- This has been testing on GNU/Linux distributions: Arch Linux, Debian (9.x), and Ubuntu (16.04, 18.04).  
- Building a debian package requires 'build-essential'.
- Main repository is on [GitLab](https://gitlab.com/BobyMCbobs/easy-deauth). There is a [GitHub](https://github.com/BobyMCbobs/easy-deauth) mirror.
