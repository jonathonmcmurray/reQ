#!/bin/bash

BUILD_VER=${1}

echo Building req_${BUILD_VER}.q...
cat req/url.q req/cookie.q req/b64.q req/status.q req/req.q req/auth.q req/multipart.q > req_${BUILD_VER}.q

echo Building req-${BUILD_VER}.tar.gz...
mkdir req-${BUILD_VER}
cp req/url.q req/cookie.q req/b64.q req/status.q req/req.q req/auth.q req/multipart.q req-${BUILD_VER}/
tar -czvf req-${BUILD_VER}.tar.gz req-${BUILD_VER}
rm -r req-${BUILD_VER}

echo Done
