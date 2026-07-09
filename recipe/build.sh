#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

# log4cpp's shipped ./configure runs AC_CHECK_LIB(nsl, gethostbyname). On Linux that
# finds libnsl and prepends -lnsl to LIBS, which libtool bakes into liblog4cpp as a
# DT_NEEDED on libnsl.so.3 -- even though gethostbyname (and gethostbyaddr/inet_addr)
# resolve from libc and NO libnsl symbols are actually used (a pure over-link). That
# phantom NEEDED makes liblog4cpp fail to load in any environment without libnsl, e.g.
# python >=3.13 which dropped its libnsl dependency (PEP 594 removed the `nis` module).
# Tell configure not to link libnsl; gethostbyname is provided by libc.
export ac_cv_lib_nsl_gethostbyname=no

./configure --prefix="${PREFIX}" \
            --host="${HOST}" \
            --build="${BUILD}"

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
make install

# don't install static library
rm -f "$PREFIX/lib/liblog4cpp.a"
