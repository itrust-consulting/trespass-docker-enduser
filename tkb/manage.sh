#!/bin/bash

REPO_PATH=/opt/svn/trespass-svn.itrust.lu/TREsPASS_KB

rm -R /usr/src/app

ln -s /opt/svn/trespass-svn.itrust.lu/TREsPASS_KB /usr/src/app

CURRENT_REV=0
MEM_REV=0

cd /usr/src/app/

while true;do
#	echo "Checking if new version..."
	MEM_REV=$(svn info $REPO_PATH | grep "Last Changed Rev:" | grep -o "[0-9]*")
	if [[ $MEM_REV -gt $CURRENT_REV ]]; then
		echo "New version, killing current python command"
		PROCESS_ID=$(ps aux | grep "python ./webserve.py" |grep -v grep |awk '{print $2}')
		if [ ! -z "$PROCESS_ID" ]; then
			kill -TERM $PROCESS_ID
			wait $PROCESS_ID
			unset PROCESS_ID
		fi
		echo "Lauching new python script"
		nohup python ./webserve.py &
		CURRENT_REV=$MEM_REV
	else
		echo "No new version" >> /dev/null
	fi
	sleep 10
done
