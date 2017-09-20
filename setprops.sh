#!/usr/bin/env bash
arg="$1"
editor="nano"

# property files to modify
paths="$BDE_ROOT_DIR/BDEEventDetection/BDEClustering/res/clustering.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/locextractor.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/entextractor.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/news.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogs.properties"

for p in $paths ; do
	[ ! -f "$p" ] && echo "File [$p] does not exist (run initialization first ?)." && continue
	if [ ! -z "$arg" ]; then
	    if [ -z "$(echo $p | grep $arg)" ]; then
		continue;
	    fi
	fi
	echo "[$p]"
	$editor $p
done

