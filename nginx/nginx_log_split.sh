#!/bin/bash
#Date:          2013-01-28
#Author:        Created by Boomer
#Mail:          990370200@qq.com
#Version:       1.0
#Function:      This script is cut nginx log 
####This script run at 00:00
####The Nginx logs path
####clean log's  15 days ago

#########################

#crontab -e
#cut nginx access log by mean at 20150601
#00 00 * * * /bin/sh /server/scripts/nginx_log_split.sh > /dev/null 2>&1
#00 00 * * * /usr/bin/find /data/nginx/access_log/ -type d -mtime +15 | xargs rm -rf

##########################

#source function library
#. /etc/init.d/functions
logs_path="/usr/local/nginx/logs"
logs_path1="/data/nginx/access_log"
nginx_pid="/usr/local/nginx/logs/nginx.pid"
host_ip=`hostname`
PID=`cat ${nginx_pid}`
#create log directory
mkdir -p ${logs_path1}/$(date -d "yesterday" +"%Y%m%d")/

#move log to new directory
#mv ${logs_path}/access.log ${logs_path1}/$(date -d "yesterday" +"%Y%m%d")/$host_ip-access.log
#mv ${logs_path}/error.log ${logs_path1}/$(date -d "yesterday" +"%Y%m%d")/$host_ip-error.log
for i in `ls ${logs_path} | grep -v "nginx.pid"`
do
	mv $logs_path/$i ${logs_path1}/$(date -d "yesterday" +"%Y%m%d")/$(date -d "yesterday" +"%Y-%m-%d")-$i
done

#make new log
kill -s USR1 $PID
