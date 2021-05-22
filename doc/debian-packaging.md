# Building Debian packages

## Notes

```sh
sudo apt install dh-make
#https://gitlab.kitware.com/debian/dh-cmake
sudo apt install dh-cmake
sudo apt install equivs
sudo apt install dh-r
```

### Creating the libconfig-utils-dev pkg

```sh
pkgname=libconfig-utils-dev
pkgname_ver=${pkgname}-1.0
fn_ver=${pkgname}_1.0
SRC=~/src/github_jm/config-utils
DEST=~/tmp/confutils/${pkgname_ver}
FILES="catch  cmake  debian  doc  LICENSE.txt  Makefile  README.md"

mkdir -p ${DEST}
cd ${DEST}
rm -rf ${DEST}/*
cd ${SRC}
cp -Rf ${FILES} ${DEST}/
cd ${DEST}
# rm -rf ./obj-x86_64-linux-gnu
# rm -rf ./debian/libconfig-utils-dev  # whu not a tmp folder like other pkg?
ls -a
cd ${DEST}/..
tar -zcvf ${fn_ver}.orig.tar.gz ${pkgname_ver}
cd ${DEST}
debuild -us -uc 
```

Check:

```sh
cd ${DEST}/..
dpkg -c libconfig-utils-dev_1.0-1_amd64.deb 
sudo dpkg -i libconfig-utils-dev_1.0-1_amd64.deb 
```

### Creating the r-msvs pkg

Possibly `sudo apt install r-cran-generics r-cran-rcpp`. 

```sh
pkgname=r-msvs
pkgname_ver=${pkgname}-0.4
fn_ver=${pkgname}_0.4
SRC=~/src/github_jm/config-utils/R/packages/msvs
DEST=~/tmp/msvs/${pkgname_ver}
FILES="./*"

mkdir -p ${DEST}
cd ${DEST}
rm -rf ${DEST}/*
cd ${SRC}
cp -Rf ${FILES} ${DEST}/
cd ${DEST}
ls -a
cd ${DEST}/..
tar -zcvf ${fn_ver}.orig.tar.gz ${pkgname_ver}
cd ${DEST}
debuild -us -uc 
```

Check:

```sh
cd ${DEST}/..
dpkg -c r-msvs_0.4-1_amd64.deb 
```
