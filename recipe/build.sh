#!/bin/bash

./configure --prefix="${PREFIX}"

# Removing these folders because the `make check` is failing, it seems that it tries to build bcb5 and msvc. (it fails just for osx, however as this is not not necessary for linux I'm removing for both osx and linux)
rm -R msvc6
rm -R msvc7
rm -R msvc10
rm -R bcb5

make -j${CPU_COUNT}
make check
make install
