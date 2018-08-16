Name:           easy-deauth
Version:        1.1
Release:        1%{?dist}
Summary:        Send deauth packages to your favourite devices on your private WiFi network!
BuildArch:	noarch
License:        GPL-2.0
Group:		Productivity/Networking/Other
URL:            https://gitlab.com/BobyMCbobs/%{name}
Source0:        https://gitlab.com/BobyMCbobs/%{name}/-/archive/%{version}/%{name}-%{version}.zip
Requires:       aircrack-ng
Requires:	systemd
BuildRequires:	unzip

%description
Send deauth packages to your favourite devices on your private WiFi network!
As this ultimately relies on aircrack-ng, all of the work for this program is in the programs from that package.
easy-deauth just scripts it, to make it more straight forward and easier.
(Previously named deauthAttackMadeEasy)


%prep
%autosetup


%build


%install
%{__make} DESTDIR=$RPM_BUILD_ROOT install


%files
%license LICENSE
%doc README.md
%dir /usr/bin
/usr/bin/easy-deauth


%changelog
* Fri May 25 2018 caleb
- Init to RPM

