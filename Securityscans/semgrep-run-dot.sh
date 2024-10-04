#!/bin/sh

SEMGREP_TAG=sha-256ba88
SOURCE=${1}
BRANCH=${2:-master}
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
OUTPUTDIR=~/SecurityScans/$TIMESTAMP
FINDING=semgrepFindings.json
FINDINGFORMATTED=semgrepFindings2.json

SEMGREPCONF="--config p/security-audit --config p/secrets --config p/default --config p/c --config p/jwt --config p/docker --config p/gitlab --config p/csharp --config p/comment  --config p/gitleaks --config p/lockfiles --config p/xss --config p/dockerfile --config p/cwe-top-25 --config p/owasp-top-ten --config p/sql-injection --config p/docker-compose --config p/security-code-scan --config p/semgrep-misconfigurations"

SEMEXCLUDE=$(--exclude='tests' --exclude='test')

echo Preparing directories...
mkdir $OUTPUTDIR
OUTPUTDIR=$OUTPUTDIR/$(basename "$SOURCE")
mkdir $OUTPUTDIR

echo Updating repro...
cd $SOURCE
git checkout $BRANCH
git pull
git clean -f -d -x
cd -

echo Fetching container   
docker pull returntocorp/semgrep:$SEMGREP_TAG

echo Running scan...
echo x:$SEMGREPCONF
echo y:$SEMEXCLUDE

docker run -t -v $SOURCE:/path -v "$OUTPUTDIR/":/output returntocorp/semgrep semgrep  --metrics off $SEMGREPCONF --max-target-bytes 2000000 --force-color --max-chars-per-line 1000   --json --output /output/$FINDING /path  

echo Fixing json
python3 -m json.tool $OUTPUTDIR/$FINDING > $OUTPUTDIR/$FINDINGFORMATTED

echo Findings $(grep -c "check_id" $OUTPUTDIR/$FINDINGFORMATTED)
