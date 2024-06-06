#!/bin/bash

unset CDPATH
set -u +o histexpand
set -e

DESCRPTION='NoteBook Fan Control ported to Linux'
MAINTAINER='Benjamin Abendroth <braph93@gmx.de>'
LICENSE='GPL-3.0'
URL='https://github.com/nbfc-linux/nbfc-linux'

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

fpm \
  -v $VERSION \
  -m "$MAINTAINER" \
  -n nbfc-linux \
  --license "$LICENSE" \
  --url "$URL" \
  --description "$DESCRPTION" \
  -s dir -t deb *

mv *.deb ../..
