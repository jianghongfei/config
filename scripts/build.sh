#!/bin/bash

# Import Product and url
source config

ROOT=`pwd`

echo -e "\033[35m================================= VARIABLES ==================================="
echo "PRODUCT=$PRODUCT"
echo "URL=$URL"
echo "BRANCH=$BRANCH"
echo "TARGET=$TARGET"
echo "BUILDPS=$ROOT/source/$BUILDPS"
echo "ROOT=$ROOT"
echo -e "===============================================================================\033[0m"

mkdir -p "$ROOT/output"

if [[ -e "$ROOT/source/.git" ]]; then
    echo 'Revert all changes'
    cd "$ROOT/source"
    echo `pwd`
    
    git clean -fdx
    git reset --hard FETCH_HEAD

    # force pull to override everything, http://stackoverflow.com/a/9589927
    if [[ -v BRANCH ]]; then
    	git fetch origin $BRANCH
    else
    	git fetch origin master
    fi
elif [[ -v BRANCH ]]; then
    git clone $URL --branch $BRANCH "$ROOT/source"
    cd $ROOT/source
else 
    git clone $URL "$ROOT/source"
    cd $ROOT/source
fi

echo -e "\033[35m============================= CURRENT COMMIT ==================================\033[0m"
git log -1 --oneline
echo -e "\033[35m===============================================================================\033[0m"
sleep 2

cd $ROOT

mkdir -p $TARGET

powershell -ExecutionPolicy unrestricted $ROOT\\source\\$BUILDPS $ROOT $ROOT\\metadata.xml $TARGET < /dev/null
