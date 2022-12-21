export RELEASE_MANAGER=per202
export RELEASE_VERSION=1_0_0

INSTALL_PREFIX?=/usr/local

# Default target executed when no arguments are given to make.
default_target: all

all: build

build:
	echo "Nothing to do as build"

install:
	mkdir -p $(INSTALL_PREFIX)/include/catch
	cp ./catch/include/catch/catch*.hpp $(INSTALL_PREFIX)/include/catch/
	mkdir -p $(INSTALL_PREFIX)/share/cmake/Modules
	cp -r ./cmake/Modules/*.cmake $(INSTALL_PREFIX)/share/cmake/Modules/

uninstall:
	rm $(INSTALL_PREFIX)/include/catch/catch*.hpp
	cd ./cmake/Modules;
	ff=`ls *.cmake`
	cd $(INSTALL_PREFIX)/share/cmake/Modules
	if [ $? != 0 ]; then exit $?; fi
	rm ${ff}


