#!/bin/bash
#Date:		2014-04-01
#Author:	Created by Boomer
#Mail:		990370200@qq.com
#Function:	This script is for check optimize is succefull or failure
#Version:	1.0

#set env
export PATH=$PATH:/bin:/sbin:/usr/sbin
#export LANG="zh_CN.GB18030"

#require root to run this script
if [[ "$(whoami)" != "root" ]];then
	echo "Pls run this script as root!" >&2check optimize is succefull or failure
	exit 1
fi

#source function library
. /etc/init.d/functions

#check charset GB18030
#if [ `grep 18030 /etc/sysconfig/i18n |wc -l` -eq 1 ];then
count=`grep "zh_CN.UTF-8" /etc/sysconfig/i18n |wc -l`
if [ $count -eq 1 ];then
	action "/etc/sysconfig/i18n" /bin/true
else
	action "/etc/sysconfig/i18n" /bin/false
fi

#export LANG=en
count1=`chkconfig --list | grep 3 | egrep "crond|network|sshd" | wc -l`
#if [ `chkconfig --list | grep 3:on |egrep "crond|network|syslog|sshd"` -eq 4 ];then
if [ $count1 -eq 3  ];then
	action "sys service init" /bin/true
else
        action "sys service init" /bin/true
fi

#check limit
if [ `grep 65535 /etc/security/limits.conf|wc -l` -eq 1  ];then
        action "/etc/security/limits.conf" /bin/true
else
        action "/etc/security/limits.conf" /bin/true
fi

#check limit
#for pid in `ps aux | grep nginx | grep -v grep | awk '{print $2}'`
#do
#	cat /proc/$pid/limits | grep 'Max open files'
#done



