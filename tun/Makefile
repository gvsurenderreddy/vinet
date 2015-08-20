#
# ip tunnel/ethertap driver for MacOSX
#
# Makefile
#
# (c) 2004, 2005, 2006, 2007, 2008 Mattias Nissler
#

OBJS = ../tuntap.o ../tuntap_mgr.o ../lock.o ../mem.o \
	kmod.o tun_inet_proto.o tun_inet6_proto.o tun.o
KMOD_BIN = tun
BUNDLE_DIR = ..
BUNDLE_NAME = tun.kext

TUN_KEXT_VERSION = $(TUNTAP_VERSION)

BUNDLE_REGION = English
BUNDLE_IDENTIFIER = net.sf.tuntaposx.tun
BUNDLE_SIGNATURE = ????
BUNDLE_PACKAGETYPE = KEXT
BUNDLE_VERSION = $(TUN_KEXT_VERSION)

INCLUDE = -I.. -I/System/Library/Frameworks/Kernel.framework/Headers
CFLAGS = -Wall -Werror -mkernel -force_cpusubtype_ALL \
	-nostdinc -fno-builtin -fno-stack-protector -msoft-float -fno-common \
	-arch x86_64 \
	-DKERNEL -DAPPLE -DKERNEL_PRIVATE -DTUNTAP_VERSION=\"$(TUNTAP_VERSION)\" \
	-DTUN_KEXT_VERSION=\"$(TUN_KEXT_VERSION)\"
CCFLAGS = $(CFLAGS)
LDFLAGS = -Wall -Werror -arch x86_64 -Xlinker -kext -nostdlib -lkmodc++ -lkmod -lcc_kext

CCP = clang -x c++
CC = clang -x c
LD = clang

all: $(KMOD_BIN) bundle

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@
.cc.o:
	$(CCP) $(CCFLAGS) $(INCLUDE) -c $< -o $@

$(KMOD_BIN):	$(OBJS)
	$(LD) $(LDFLAGS) -o $(KMOD_BIN) $(OBJS)

bundle:	$(KMOD_BIN)
	rm -rf $(BUNDLE_DIR)/$(BUNDLE_NAME)
	mkdir -p $(BUNDLE_DIR)/$(BUNDLE_NAME)
	cp $(KMOD_BIN) $(BUNDLE_DIR)/$(BUNDLE_NAME)

clean:
	-rm -f $(OBJS) $(KMOD_BIN)
	-rm -rf $(BUNDLE_DIR)/$(BUNDLE_NAME)
