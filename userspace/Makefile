# make libxt_XOR.so
# copy to /lib64/xtables/
IDIR =../include
CFLAGS = -O2 -Wall -I$(IDIR)
xtablesdir = $(shell pkg-config xtables --variable xtlibdir)

all: libxt_XOR.so

install: all
	cp libxt_XOR.so ${xtablesdir}/

uninstall:
	rm -f ${xtablesdir}/libxt_XOR.so

clean:
	rm -f *.o libxt_XOR.so

lib%.so: lib%.o
	gcc -shared -o $@ $^
	chmod -x $@
lib%.o: lib%.c
	gcc ${CFLAGS} -fPIC -c -o $@ $<

	
