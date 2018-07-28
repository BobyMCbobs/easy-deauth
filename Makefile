PREFIX ?= /usr

all: help

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -p easy-deauth $(DESTDIR)$(PREFIX)/bin
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/easy-deauth

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/easy-deauth

prep-deb:
	@mkdir -p build/easy-deauth
	@cp -p -r support/debian build/easy-deauth/debian
	@mkdir build/easy-deauth/debian/easy-deauth
	@make DESTDIR=build/easy-deauth/debian/easy-deauth install

deb-pkg: prep-deb
	@cd build/easy-deauth/debian && debuild -b

deb-src: prep-deb
	@cd build/easy-deauth/debian && debuild -S

build-zip:
	@mkdir -p build/easy-deauth
	@make DESTDIR=build/easy-deauth install
	@cd build/easy-deauth && zip -r ../easy-deauth.zip .

clean:
	@rm -r build

help:
	@echo "Read 'README.md' for info on building."
