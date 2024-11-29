PACKAGE_NAME = $(shell awk -F= '/^Package:/ { print $$2 }' debian/control)
ARCH=$(shell awk -F= '/^Architecture:/ { print $$2 }' debian/control)
VERSION=$(shell awk -F[\(\)] '/^$(PACKAGE_NAME)/ {print $$2}' debian/changelog | head -1)

.PHONY: userspace

all: userspace

clean:
	make -C $$PWD/kernel $@
	make -C $$PWD/userspace $@

userspace:
	make -C $$PWD/userspace all
	
install:
	echo $(DESTDIR)
	mkdir -p $(DESTDIR)/usr/lib/x86_64-linux-gnu/xtables $(DESTDIR)/usr/src/xt_XOR-$(VERSION)
	cp userspace/*.so $(DESTDIR)/usr/lib/x86_64-linux-gnu/xtables
	cp kernel/xt_XOR.c kernel/Makefile include/xt_XOR.h dkms.conf $(DESTDIR)/usr/src/xt_XOR-$(VERSION)
	sed -i 's/##VERSION##/$(VERSION)/' $(DESTDIR)/usr/src/xt_XOR-$(VERSION)/dkms.conf
	
deb:
	debuild --no-lintian --no-sign -b