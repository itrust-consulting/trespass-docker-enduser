#!/bin/bash

APPSERVER_PATH=/opt/appserver

CURRENT_REV=""
MEM_REV=""

cd $APPSERVER_PATH

while true;do
#	/trustcert.sh
	echo "Checking if new version..." > /dev/null
	MEM_REV=$(sha256sum $APPSERVER_PATH/AppServer.jar)
	if [[ "$MEM_REV" != "$CURRENT_REV" ]]; then
		echo "New version, killing current appserver"
		PROCESS_ID=$(ps aux | grep "java -jar $APPSERVER_PATH/AppServer.jar" |grep -v grep |awk '{print $2}')
		if [ ! -z "$PROCESS_ID" ]; then
			kill -TERM $PROCESS_ID
			wait $PROCESS_ID
			unset PROCESS_ID
		fi
		echo "Lauching new appserver"
		nohup java -jar $APPSERVER_PATH/AppServer.jar &
		CURRENT_REV=$MEM_REV
	else
		echo "No new version" > /dev/null
	fi
	sleep 10
done
