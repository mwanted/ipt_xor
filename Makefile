PACKAGE_NAME = $(shell awk -F= '/^PACKAGE_NAME=/ { print $$2 }' VERSION)
ARCH=$(shell awk -F= '/^ARCH=/ { print $$2 }' VERSION)
VERSION=$(shell awk -F= '/^VERSION=/ { print $$2 }' VERSION)

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
	
deb:
	debuild --no-lintian --no-sign -b