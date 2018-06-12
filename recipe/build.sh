#!/bin/bash

./configure --prefix "${PREFIX}" --libdir="${PREFIX}/lib"

make -j${CPU_COUNT}
make check
make install
