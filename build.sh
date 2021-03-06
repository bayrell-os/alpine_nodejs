#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=12.15
SUBVERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	test)
		docker build ./ -t bayrell/alpine_nodejs:$VERSION-$SUBVERSION-$TAG --file Dockerfile
	;;
	
	amd64)
		docker build ./ -t bayrell/alpine_nodejs:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=-amd64
	;;
	
	arm32v7)
		docker build ./ -t bayrell/alpine_nodejs:$VERSION-$SUBVERSION-arm32v7 \
			--file Dockerfile --build-arg ARCH=-arm32v7
	;;
	
	manifest)
		docker push bayrell/alpine_nodejs:$VERSION-$SUBVERSION-amd64
		docker push bayrell/alpine_nodejs:$VERSION-$SUBVERSION-arm32v7
		
		docker manifest create bayrell/alpine_nodejs:$VERSION-$SUBVERSION \
			--amend bayrell/alpine_nodejs:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/alpine_nodejs:$VERSION-$SUBVERSION-arm32v7
		docker manifest push bayrell/alpine_nodejs:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/alpine_nodejs:$VERSION \
			--amend bayrell/alpine_nodejs:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/alpine_nodejs:$VERSION-$SUBVERSION-arm32v7
		docker manifest push bayrell/alpine_nodejs:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm32v7|manifest|all|test}"
		RETVAL=1

esac

exit $RETVAL

