Name:           getnewip
Version:        2.2
Release:        1%{?dist}
Summary:        Sync dynamic public IP address of GNU/Linux servers with the hostname in a user's SSH config, via Dropbox.
BuildArch:	noarch
License:        GPLv3
URL:            https://gitlab.com/BobyMCbobs/%{name}
Source0:        https://gitlab.com/BobyMCbobs/%{name}/-/archive/%{version}/%{name}-%{version}.zip
Requires:       bash, nc, curl, openssh-clients


%description
Sync dynamic public IP address of GNU/Linux servers with the hostname in a user's SSH config via Dropbox.


%prep
%autosetup


%install
%{__make} DESTDIR=$RPM_BUILD_ROOT install


%files
%license LICENSE
%doc README.md
/usr/bin/%{name}
/usr/share/bash-completion/completions/%{name}
/etc/systemd/system/%{name}.service
/etc/%{name}/%{name}-blank.conf
/etc/%{name}/%{name}-settings.conf


%preun
systemctl disable getnewip
systemctl stop getnewip


%post
mkdir -p /etc/getnewip/units


%postun
rm -rf /etc/getnewip


%changelog
* Fri May 25 2018 caleb
- Init to RPM

