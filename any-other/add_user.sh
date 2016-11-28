#!/bin/bash
#Date:          2013-06-06
#Author:        Created by Boomer
#Mail:          990370200@qq.com
#Function:      This script is for add the user
#Version:       1.0

#source function library
. /etc/init.d/functions

#Batch build account, password
function batch_add_user(){
for i in $(seq -w 10)	#输出为01,02,03...10
do
	useradd user$n
	echo "$n" | passwd --stdin my-$n
done
}


function ip_add(){
for ip in 192.168.2.100 192.168.2.99
do
	for ii in `seq 1 50`
		do
			ssh $ip useradd user $ii
			ssh $ip "echo "123" | passwd --stdin user$ii"
		done
done
}

function produ(){
> /tmp/userpwd.txt
> /tmp/fail_userpwd.txt	#Clear the password before
. /etc/init.d/functions	#The loading system function library
for n in $(seq -w 10)	#output:01,02,03...10
do
	passwd=`echo $(date +%t%N)$RANDOM |md5sum |cut -c 2-9`	#passwd需要定义，不定义密码会变化
	useradd user$n >&/dev/null && user_status=$?
	echo $"$passwd" | passwd --stdin user$n >&/dev/null && pass_status=$?

	if [ $user_status -eq 0 -a $pass_status -eq 0 ];then
		action "adduser user$n" /bin/true
		echo -e "user:\tuser$n pass:\t$passwd" >> /tmp/userpwd.txt
	else
		action "adduser user$n" /bin/false
		echo -e "user:\tuser$n pass:\t$passwd" >> /tmp/fail_userpwd.txt
	fi  
done
	echo "The password is stored in the:/tmp/userpwd.txt,/tmp/fail_userpwd.txt"
}

function deluser(){
. /etc/init.d/functions #The loading system function library
for n in $(seq -w 10)   #output:01,02,03...10
do
    userdel -r  user$n >&/dev/null && user_status=$?
    if [ $user_status -eq 0 ];then
        action "deluser user$n" /bin/true
    else
        action "deluser user$n" /bin/false
    fi
done
}

produ


