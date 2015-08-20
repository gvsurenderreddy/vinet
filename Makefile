TUNTAP_VERSION = 20150118
BASE=

all: tap.kext tun.kext

keysetup:
	-security delete-keychain com.two718
	security create-keychain -p $$(head -c 32 /dev/urandom | hexdump -e '"%02x"') com.two718
	security set-keychain-settings -lut 60 com.two718 security import identity.p12 -k com.two718 -f pkcs12 -P $$(read -sp 'identity passphrase: ' pw && echo "$$pw") -A
	security find-identity -v com.two718 | awk -F \" '$$2 ~ /^Developer ID Application:/ { print $$2 }' > .signing_identity
	security find-identity -v com.two718 | awk -F \" '$$2 ~ /^Developer ID Installer:/ { print $$2 }' > .installer_identity

install: install_tap_kext install_tun_kext

tarball: clean
	touch tuntap_$(TUNTAP_VERSION)_src.tar.gz
	tar czf tuntap_$(TUNTAP_VERSION)_src.tar.gz \
		-C .. \
		--exclude "tuntap/identity.p12" \
		--exclude "tuntap/tuntap_$(TUNTAP_VERSION).tar.gz" \
		--exclude "*/.*" \
		tuntap

clean:
	cd ./tap && make -f Makefile clean
	cd ./tun && make -f Makefile clean
	-rm -f tuntap_$(TUNTAP_VERSION).tar.gz

%.kext:
	cd ./$* && make TUNTAP_VERSION=$(TUNTAP_VERSION) -f Makefile all
