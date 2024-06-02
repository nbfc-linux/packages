#!/bin/bash

unset CDPATH
set -u +o histexpand
set -e

[[ -e 'nbfc-linux' ]] || \
  git clone https://github.com/nbfc-linux/nbfc-linux

cd nbfc-linux
VERSION=$(grep AC_INIT configure.ac | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' )
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc --bindir=/usr/bin
make
rm -rf build
mkdir build
make DESTDIR=build install
cd build
fpm -s dir -t rpm -n nbfc-linux -v $VERSION *
mv *.rpm ../..
