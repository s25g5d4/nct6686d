obj-m += nct6686.o

curpwd      := $(shell pwd)
kver        := $(shell uname -r)
commitcount := $(shell git rev-list --all --count)
commithash  := $(shell git rev-parse --short HEAD)


build:
	rm -rf ${curpwd}/${kver}
	mkdir -p ${curpwd}/${kver}
	cp ${curpwd}/Makefile ${curpwd}/nct6686.c ${curpwd}/${kver}
	cd ${curpwd}/${kver}
	make -C /lib/modules/${kver}/build M=${curpwd}/${kver} modules
install: build
	sudo cp ${curpwd}/${kver}/nct6686.ko /lib/modules/${kver}/kernel/drivers/hwmon/nct6686.ko
	sudo depmod
	sudo modprobe nct6686
clean:
	[ -d "${curpwd}/${kver}" ] && make -C /lib/modules/${kver}/build M=${curpwd}/${kver} clean


akmod/build:
	sudo dnf groupinstall -y "Development Tools"
	sudo dnf install -y rpmdevtools kmodtool
	mkdir -p ${curpwd}/.tmp/nct6686d-1.0.${commitcount}/nct6686d
	cp LICENSE Makefile nct6686.c ${curpwd}/.tmp/nct6686d-1.0.${commitcount}/nct6686d
	cd .tmp && tar -czvf nct6686d-1.0.${commitcount}.tar.gz nct6686d-1.0.${commitcount} && cd -
	mkdir -p ${curpwd}/.tmp/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	cp ${curpwd}/.tmp/nct6686d-1.0.${commitcount}.tar.gz ${curpwd}/.tmp/rpmbuild/SOURCES/
	echo 'nct6686' | tee ${curpwd}/.tmp/rpmbuild/SOURCES/nct6686.conf
	cp fedora/*.spec ${curpwd}/.tmp/rpmbuild/SPECS/
	sed -i "s/MAKEFILE_PKGVER/${commitcount}/g" ${curpwd}/.tmp/rpmbuild/SPECS/*
	sed -i "s/MAKEFILE_COMMITHASH/${commithash}/g" ${curpwd}/.tmp/rpmbuild/SPECS/*
	rpmbuild -ba --define "_topdir ${curpwd}/.tmp/rpmbuild" ${curpwd}/.tmp/rpmbuild/SPECS/nct6686d.spec
	rpmbuild -ba --define "_topdir ${curpwd}/.tmp/rpmbuild" ${curpwd}/.tmp/rpmbuild/SPECS/nct6686d-kmod.spec
akmod/install: akmod/build
	sudo dnf install ${curpwd}/.tmp/rpmbuild/RPMS/*/*.rpm
akmod/clean:
	sudo dnf remove nct6686d
	rm -rf .tmp
akmod: akmod/install


dkms/build:
	make -C /lib/modules/${kver}/build M=${curpwd} modules

dkms/install:
	rm -rf ${curpwd}/dkms
	mkdir -p ${curpwd}/dkms
	cp ${curpwd}/dkms.conf ${curpwd}/Makefile ${curpwd}/nct6686.c ${curpwd}/dkms
	sudo rm -rf /usr/src/nct6686d-1
	sudo cp -rT dkms /usr/src/nct6686d-1
	sudo dkms install nct6686d/1
	sudo modprobe nct6686

dkms/clean:
	sudo dkms remove nct6686d/1 --all
	make -C /lib/modules/${kver}/build M=${curpwd} clean

debian/changelog: FORCE
	git --no-pager log \
		--format='nct6686d-dkms (%ad) unstable; urgency=low%n%n  * %s%n%n -- %aN <%aE>  %aD%n' \
		--date='format:%Y%m%d-%H%M%S' \
		> $@

deb: debian/changelog
	sudo apt install -y debhelper dkms
	dpkg-buildpackage -b -rfakeroot -us -uc

.PHONY: FORCE
FORCE:
