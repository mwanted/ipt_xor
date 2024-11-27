#PACKAGE_NAME=$(shell awk -F= '/^PACKAGE_NAME=/ { print $2 }' VERSION)
#BUILD_ROOT=$(shell awk -F= '/^BUILD_ROOT=/ { print $2 }' VERSION)
#ARCH=$(shell awk -F= '/^ARCH=/ { print $2 }' VERSION)
#VERSION=$(shell awk -F= '/^VERSION=/ { print $2 }' VERSION)

PACKAGE_NAME=libiptxor
BUILD_ROOT=/tmp
ARCH=amd64
VERSION=0.0.1
OUTPUT_PATH=$(BUILD_ROOT)/$(PACKAGE_NAME)-$(VERSION)-$(ARCH)
DESTDIR=$(OUTPUT_PATH)/buildtree
PACKETROOT=$(DESTDIR)/debian/$(PACKAGE_NAME)

all:
	make -C $$PWD/kernel $@
	make -C $$PWD/userspace $@
	
clean:
	make -C $$PWD/kernel $@
	make -C $$PWD/userspace $@
	
modules:
	make -C $$PWD/kernel $@
	make -C $$PWD/userspace all

modules_install:
	make -C $$PWD/kernel $@ 
	make -C $$PWD/userspace install
	
deb:
	rm -rf $(OUTPUT_PATH)
	mkdir -p $(PACKETROOT)
	cp debian/changelog debian/control debian/copyright debian/postinst debian/prerm debian/rules $(DESTDIR)/debian/
	mkdir -p $(PACKETROOT)/usr/lib/x86_64-linux-gnu/xtables $(PACKETROOT)/usr/src/xt_XOR-$(VERSION)
	cp userspace/*.so $(PACKETROOT)/usr/lib/x86_64-linux-gnu/xtables
	cp kernel/xt_XOR.c kernel/Makefile include/xt_XOR.h dkms.conf $(PACKETROOT)/usr/src/xt_XOR-$(VERSION)
	sed -i 's/##VERSION##/$(VERSION)/' $(PACKETROOT)/usr/src/xt_XOR-$(VERSION)/dkms.conf
	cd $(DESTDIR); debuild --no-lintian -b
	