#! /bin/sh

: ${R_HOME=$(R RHOME)}
RSCRIPT_BIN=${R_HOME}/bin/Rscript
NCORES=`${RSCRIPT_BIN} -e "cat(min(2, parallel::detectCores(logical = FALSE)))"`

cd src

#### CMAKE CONFIGURATION ####
. ./scripts/cmake_config.sh

# compile gflags from source ###################################################
sh ./scripts/gflags_download.sh ${RSCRIPT_BIN}
dot() { file=$1; shift; . "$file"; }
dot ./scripts/r_config.sh ""
${RSCRIPT_BIN} --vanilla -e 'getRversion() > "4.0.0"' | grep TRUE > /dev/null
if [ $? -eq 0 ]; then
  CMAKE_ADD_AR="-D CMAKE_AR=${AR}"
  CMAKE_ADD_RANLIB="-D CMAKE_RANLIB=${RANLIB}"
else
  CMAKE_ADD_AR=""
  CMAKE_ADD_RANLIB=""
fi
mkdir gflags-build
mkdir gflags
cd gflags-build
${CMAKE_BIN} \
    -D CMAKE_BUILD_TYPE=Release \
    -D BUILD_STATIC_LIBS=ON \
    -D CMAKE_INSTALL_PREFIX=../gflags \
  ${CMAKE_ADD_AR} ${CMAKE_ADD_RANLIB} ../gflags-src
make -j${NCORES}
make install
cd ..
mv gflags/lib* gflags/lib
##mv gflags/lib/* ../inst/

# compile glog from source #####################################################
sh ./scripts/glog_download.sh ${RSCRIPT_BIN}
dot() { file=$1; shift; . "$file"; }
dot ./scripts/r_config.sh ""
${RSCRIPT_BIN} --vanilla -e 'getRversion() > "4.0.0"' | grep TRUE > /dev/null
if [ $? -eq 0 ]; then
  CMAKE_ADD_AR="-D CMAKE_AR=${AR}"
  CMAKE_ADD_RANLIB="-D CMAKE_RANLIB=${RANLIB}"
else
  CMAKE_ADD_AR=""
  CMAKE_ADD_RANLIB=""
fi
mkdir glog-build
mkdir glog
cd glog-build
${CMAKE_BIN} \
    -D BUILD_SHARED_LIBS=OFF \
    -D BUILD_TESTING=OFF \
    -D CMAKE_INSTALL_PREFIX=../glog \
    -D WITH_GMOCK=OFF \
    -D WITH_GTEST=OFF \
    -D WITH_UNWIND=OFF \
    -D gflags_DIR=../gflags/lib/cmake/gflags \
  ${CMAKE_ADD_AR} ${CMAKE_ADD_RANLIB} ../glog-src
# ${CMAKE_BIN} -S . -B glog-build -G  "Unix Makefiles"
make -j${NCORES}
make install
cd ..
mv glog/lib* glog/lib
## mv glog/lib/* ../inst/

# Cleanup
sh ./scripts/Rcppglog_cleanup.sh
