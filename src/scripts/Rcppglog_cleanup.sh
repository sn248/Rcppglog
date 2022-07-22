#!/bin/sh

cp gflags/lib/*.a ../inst/
cp glog/lib/*.a ../inst/

cp -R glog/include/* ../inst/include/
cp -R gflags/include/* ../inst/include/

rm -fr glog-src glog-build glog
rm -fr gflags-src gflags-build gflags
