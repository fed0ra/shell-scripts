#!/bin/bash

#Applies to mail server and DNS server

#httpd port 80
netstat -an | grep 80 | grep -v LISTEN | awk '{print $5}' |sort |awk -F : '{print $4}' | uniq -c | awk '$1>100' > /root/black.txt

#mail port 25
#netstat -an | grep 80 | grep -v 127.0.0.1 | awk '{print $5}' |sort |awk -F : '{print $1}' | uniq -c | awk '$1>100' > /root/black.txt

for i in `awk '{print $2}' /root/black.txt`
do
	COUNT=`awk '{print $1}' /root/black.txt`
	DEFINE="100"
	ZERO="0"
	if [ $COUNT -gt $DEFINE ];then
		grep $i /root/white.txt > /dev/null
		if [ $? -gt $ZERO ];then
			echo "$COUNT $i"
			iptables -I INPUT -p tcp -s $i -j DROP
		fi
	fi

done




