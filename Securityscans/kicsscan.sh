#!/bin/sh

KICS_TAG=v1.7.3-alpine
MASTER=~/Scan/
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
OUTPUTDIR=~/SecurityScans/$TIMESTAMP

mkdir $OUTPUTDIR
OUTPUTDIR=$OUTPUTDIR/vtMaster
mkdir $OUTPUTDIR


docker pull checkmarx/kics:$KICS_TAG
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type OpenAPI -p /path -o /output --report-formats "glsast,html" --output-name "kics_openapi"

