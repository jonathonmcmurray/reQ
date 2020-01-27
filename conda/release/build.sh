#!/bin/bash

PKG_NAME="req"

QHOME=$PREFIX/q
mkdir -p $QHOME/packages/${PKG_NAME}-${PKG_VERSION}
cp -r ${SRC_DIR}/${PKG_NAME}/*.q $QHOME/packages/${PKG_NAME}-${PKG_VERSION}/
