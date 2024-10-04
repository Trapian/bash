#!/bin/sh

KICS_TAG=v1.7.3-alpine
MASTER=~$1
PATH2SOLUTION=$2
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
OUTPUTDIR=~/SecurityScans/$TIMESTAMP

mkdir $OUTPUTDIR
OUTPUTDIR=$OUTPUTDIR/$MASTER
mkdir $OUTPUTDIR

docker login registry.vt-fls.com

#trivy image --ignore-unfixed registry.vt-fls.com/release-candidates/server-standalone-linux@sha256:0398e39fad3fc56b77677c0fbde601da879d425def0df918883129f2ad12333d > ~/trivyScans/vtImage/$(date "+%Y.%m.%d-%H.%M.%S").txt

cd "$MASTER"
git checkout master
git pull
git clean -f -d -x
dotnet nuget locals all --clear
dotnet restore --packages .nuget "$MASTER/$PATH2SOLUTION"
cd -
trivy fs --skip-dirs "$MASTER/visitour/tests" --ignore-unfixed "$MASTER" > "$OUTPUTDIR/trivyScan_$TIMESTAMP.txt"

docker pull checkmarx/kics:$KICS_TAG
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type DockerCompose,Dockerfile -p /path -o /output --report-formats "glsast,html" --output-name "kics_docker"
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type GRPC -p /path -o /output --report-formats "glsast,html" --output-name "kics_grpc" 
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type Kubernetes -p /path -o /output --report-formats "glsast,html" --output-name "kics_kubernets" 
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type OpenAPI -p /path -o /output --report-formats "glsast,html" --output-name "kics_openapi"
docker run -t -v "$MASTER":/path -v "$OUTPUTDIR/":/output checkmarx/kics scan --type Terraform -p /path -o /output --report-formats "glsast,html" --output-name "kics_terraform"
