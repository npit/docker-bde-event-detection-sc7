#!/usr/bin/env bash

# Script to set cassandra/mysql connection host, port and twitter credentials
# to the relevant BDE Event detection pilot configuration files.

echo
echo ">Running the connection parameters setting script. ($0)"

# property files to modify
paths="$BDE_ROOT_DIR/BDEEventDetection/BDECLustering/res/clustering.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDELocationExtraction/res/location_extraction.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/newscrawler_configuration.properties"
paths+=" $BDE_ROOT_DIR/BDEEventDetection/BDERSSCrawler/res/blogcrawler_configuration.properties"

# newline-delimit, let's not change IFS
paths="$(echo $paths | sed  's/ /\n/g' )"


echo "Setting repository connection parameters and twitter credentials. ($0)"

## TWITTER
# format expected:
# twitterConsumerKey
# twitterConsumerKeySecret
# twitterAccessTokken
# twitterAccessTokkenSecret
twitterfile="$CONNECTIONS_CONFIG_FOLDER/twitter.conf"
if [ -f "$twitterfile" ]; then
	if [ "$(wc -l < $twitterfile)" -eq 4 ]; then
		twitterConsumerKey="$(cat $twitterfile | grep -v '#' | head -1 | tail -1)"
		twitterConsumerKeySecret="$(cat $twitterfile | grep -v '#' | head -2 | tail -1)"
		twitterAccessTokken="$(cat $twitterfile | grep -v '#' | head -3 | tail -1)"
		twitterAccessTokkenSecret="$(cat $twitterfile | grep -v '#' | head -4 | tail -1)"


		printf "Setting twitter :\n"
		printf "\tkey: [%s]\n" "$twitterConsumerKey"
		printf "\tkeysecret: [%s]\n" "$twitterConsumerKeySecret"
		printf "\tacctoken: [%s]\n" "$twitterAccessTokken"
		printf "\tacctokensecret: [%s]\n" "$twitterAccessTokkenSecret"

	        twitterpropsfile="$BDE_ROOT_DIR/BDEEventDetection/BDETwitterListener/res/twitter.properties"
	        if [ ! -f "$twitterpropsfile" ]; then
	                >&2 echo "File [$twitterpropsfile] not found "
	        else
	        # set the twitter credentials
	                sed -i "s/twitterConsumerKey=.*/twitterConsumerKey=$twitterConsumerKey/g" "$twitterpropsfile"
	                sed -i "s/twitterConsumerKeySecret=.*/twitterConsumerKeySecret=$twitterConsumerKeySecret/g" "$twitterpropsfile"
	                sed -i "s/twitterAccessTokken=.*/twitterAccessTokken=$twitterAccessTokken/g" "$twitterpropsfile"
	                sed -i "s/twitterAccessTokkenSecret=.*/twitterAccessTokkenSecret=$twitterAccessTokkenSecret/g" "$twitterpropsfile"
	        fi
	else
		>&2 printf "(!)Twitter credentials error. format expected:\ntwitterConsumerKey\ntwitterConsumerKeySecret\ntwitterAccessTokken\ntwitterAccessTokkenSecret\n";
	fi


else
	>&2 echo "(!) No twitter credentials were found at [$twitterfile]!"
fi




# CASSANDRA
# expecting format:
# cassandra_hosts
# cassandra_port
# cassandra_keyspace
# cassandra_cluster_name

cassandrafile="$CONNECTIONS_CONFIG_FOLDER/cassandra.conf"

if [  -f "$cassandrafile" ] ; then
	if [ "$(wc -l < $cassandrafile)" -eq 4 ]; then

	cassandraHost="$(cat $cassandrafile | grep -v '#' | head -1 | tail -1)"
	cassandraPort="$(cat $cassandrafile | grep -v '#' | head -2 | tail -1)"
	cassandraKeyspace="$(cat $cassandrafile | grep -v '#' | head -3 | tail -1)"
	cassandraCluster="$(cat $cassandrafile | grep -v '#' | head -4 | tail -1)"

	printf "\nSetting cassandra:\n"
	printf "\thost: [%s]\n" "$cassandraHost"
	printf "\tport: [%s]\n" "$cassandraPort"
	printf "\tkeyspace: [%s]\n" "$cassandraKeyspace"
	printf "\tclustname: [%s]\n" "$cassandraCluster"
	printf "\n\tto files:\n"

	for f in $paths ; do
		printf "\t%s\n" "$f"
                [ ! -f $f ] && >&2 echo "File [$f] not found" && continue;

		sed -i "s/cassandra_hosts.*/cassandra_hosts=$cassandraHost/g" $f
		sed -i "s/cassandra_port.*/cassandra_port=$cassandraPort/g" $f
		sed -i "s/cassandra_keyspace.*/cassandra_keyspace=$cassandraKeyspace/g" $f
		sed -i "s/cassandra_cluster_name.*/cassandra_cluster_name=$cassandraCluster/g" $f
	done
	else
		>&2 printf "(!)Cassandra connection params error. Format expected:\ncassandra_hosts\ncassandra_port\ncassandra_keyspace\ncassandra_cluster_name\n";
	fi


else
	>&2 echo "(!) No cassandra settings were found at [$cassandrafile]"
fi

# MYSQL
# expecting format:
# databaseHost
# databaseName
# databaseUsername
# databasePassword
mysqlfile="$CONNECTIONS_CONFIG_FOLDER/mysql.conf"
if [ -f "$mysqlfile" ]; then
	if [ "$(wc -l < $mysqlfile)" -eq 4 ]; then

		databaseHost="$(cat $mysqlfile | grep -v '#' | head -1 | tail -1)"
		databaseName="$(cat $mysqlfile | grep -v '#' | head -2 | tail -1)"
		databaseUsername="$(cat $mysqlfile | grep -v '#' | head -3 | tail -1)"
		databasePassword="$(cat $mysqlfile | grep -v '#' | head -4 | tail -1)"

		printf "Setting mysql:\n"
		printf "\thost: [%s]\n" "$databaseHost"
		printf "\tdbname: [%s]\n" "$databaseName"
		printf "\tusername: [%s]\n" "$databaseUsername"
		printf "\tpass: [%s]\n" "$databasePassword"
		printf "\n\tto files:\n"
		for f in $paths ; do

			printf "\t%s\n" "$f"
	                [ ! -f $f ] && >&2 echo "File [$f] not found" && continue;

			sed -i "s<databaseHost.*<databaseHost=$databaseHost<g" $f
			sed -i "s<databasename.*<databasename=$databaseName<g" $f
			sed -i "s<databaseUsername.*<databaseUsername=$databaseUsername<g" $f
			sed -i "s<databasePassword.*<databasePassword=$databasePassword<g" $f
		done
	else
		>&2 printf "(!) Mysql connection parameters error. Format expected:\ndatabaseHost\ndatabaseName\ndatabaseUsername\ndatabasePassword\n";
	fi

	else
		>&2 echo "(!) No mysql settings were found at [$mysqlfile]"
fi


echo "-Done setting connection information."; echo
