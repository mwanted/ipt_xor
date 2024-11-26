

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
	
	
