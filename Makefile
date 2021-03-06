.PHONY: all build test install clean deb
PACKAGE=automirror
SHELL=bash

all: build

build:
	@echo No build required

release:
	gbp dch --full --release --distribution stable --auto --git-author --commit

test:
	./runtests.sh

install:
	mkdir -p $(DESTDIR)/usr/bin $(DESTDIR)/usr/share/applications $(DESTDIR)/usr/share/icons/hicolor/scalable/apps $(DESTDIR)/usr/share/man/man1
	install -m 0755 automirror.sh -D $(DESTDIR)/usr/bin/automirror
	install -m 0644 automirror.desktop $(DESTDIR)/usr/share/applications
	install -m 0644 automirror.svg $(DESTDIR)/usr/share/icons/hicolor/scalable/apps
	ronn --pipe <README.md | gzip -9 > $(DESTDIR)/usr/share/man/man1/automirror.1.gz

clean:
	rm -Rf debian/$(PACKAGE)* debian/files out/*

deb: clean
	debuild -i -us -uc -b --lintian-opts --profile debian
	mkdir -p out
	mv ../$(PACKAGE)*.{deb,build,changes} out/
	dpkg -I out/*.deb
	dpkg -c out/*.deb

repo:
	../putinrepo.sh out/*.deb

# vim: set ts=4 sw=4 tw=0 noet : 
