#!/bin/bash
#Date:		2014-04-01
#Author:	Created by Boomer
#Mail:		990370200@qq.com
#Function:	This script is for optimize
#Version:	1.0

#set env
export PATH=$PATH:/bin:/sbin:/usr/sbin
#export LANG="zh_CN.GB18030"

#require root to run this script
if [[ "$(whoami)" != "root" ]];then
	echo "Pls run this script as root!" >&2
	exit 1
fi
#define cmd var
SERVICE=`which service`
CHKCONFIG=`which cokconfig`

#source function library
. /etc/init.d/functions

#color
RED_COLOR='\E[1;31m'
SKY_COLOR='\E[1;36m'
GREEN_COLOR='\E[1;32m'
RES='\E[0m'

#add the epel and rpm forge repo
function configYum(){
	echo ""
	echo "Config yum..."
	cd /usr/local/src
	ping -c 4 baidu.com > /dev/null
	[ ! $? -eq 0 ] && echo -e $"${RED_COLOR}Networking not configured ---> exiting${RES}" && exit 1
	wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm
	#wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm
	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
	rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
}
#install chinese package

#yum install sysstat
function installTool(){
	echo ""
	echo "Install gcc gcc-c++ vim-enhanced unzip unrar sysstat..."
	yum -y install gcc gcc-c++ vim-enhanced unzip unrar sysstat > /dev/null 2>&1
}
#charset GB18030
function initI18n(){
	echo ""
	echo "Set LANG="zh_cn.gb18030"..."
	cp /etc/sysconfig/i18n /etc/sysconfig/i18n..$(date +%F)
	#sed -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.FB18030"#g' /etc/sysconfig/i18n
    sed -i 's#LANG="en_US.UTF-8"#LANG="zh_CN.UTF-8"#g' /etc/sysconfig/i18n
	source /etc/sysconfig/i18n
	grep LANG /etc/sysconfig/i18n
	sleep 1
}
#disable selinux and closed iptables
function initFirewall(){
        echo ""
		echo "Closed iptables and selinux..."
        /etc/init.d/iptables stop
        cp /etc/selinux/config /etc/selinux/config.`date +"%Y-%m-%d_%H:%M:%S"`
        sed -i 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config
        setenforce 0
        /etc/init.d/iptables status
        grep SELINUX=disabled /etc/selinux/config
        echo -e "${GREEN_COLOR}Close iptables and selinux--->ok${RES}"
        sleep 1
}
#init auto startup service
function initService(){
	echo ""
	echo "Close no usefull service..."
	export LANG="en_US.UTF-8"
	#for i in `chkconfig --list | grep 3:on |awk '{print $1}'`;do chkconfig --level 3 $i off;done
	for i in `chkconfig --list | grep 3 |awk '{print $1}'`;do chkconfig --level 3 $i off;done
	for i in crond network syslog sshd;do chkconfig --level 3 $i on;done
	#for i in bluetooth sendmail kudzu nfslock portmap iptables autofs yum-updatesd;do chkconfig --level 3 $i off;done
	export LANG="zh_CN.FB18030"
	echo -e "${GREEN_COLOR}关闭不需要的服务--->ok${RES}"
	sleep 1
}
#set ssh
function initSsh(){
	echo ""
	echo "Modify ssh port and disable root direct access..."
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +"%Y-%m-%d_%H:%M:%S"`
	sed -i 's@#Port 22@Port 12321@g' /etc/ssh/sshd_config
	sed -i 's@#PermitRootLogin yes@PermitRootLogin no@g' /etc/ssh/sshd_config
	sed -i 's@#PermitEmptyPasswords no@PermitEmptyPasswords no@g' /etc/ssh/sshd_config	
	sed -i 's@#UseDNS yes@UseDNS no@g' /etc/ssh/sshd_config
	/etc/init.d/sshd reload && action $"modify ssh port and disable root direct access" /bin/true || action $"modify ssh port and disable root direct access" /bin/false
}
#add user
function addUser(){
	echo ""
	echo "Add sys user..."
	datetmp=`date +"%Y-%m-%d_%H:%M:%S"`
	cp /etc/sudoers /etc/sudoers.${datetmp}
	saUserArr=(system1 system)
	groupadd -g 888 sa
	for ((i=0;i<${#saUserArr[@]};i++))
		do
			#add user
			useradd -g sa -u 88${i} ${saUserArr[$i]}
			#set passwd
			echo "${saUserArr[$i]}GrwlZHYJpro89758" | passwd ${saUserArr[$i]} --stdin
			#set sudo
			[ $(grep "${saUserArr[$i]} ALL=(ALL) NOPASSWD: ALL" /etc/sudoers |wc -l) -le 0 ] && echo "${saUserArr[$i]} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
			#?????????????[ `grep "\%sa" | grep -v grep |wc -l` -ne 1 ] && echo "%sa	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers
		done
	/usr/sbin/visudo -c
	[ $? -ne 0 ] && /bin/cp /etc/sudoers.${datetmp} /etc/sudoers && echo -e $"${RED_COLOR}sudoers not configure ---> exiting${RES}" && exit 1
	action $"add user succsfull" /bin/true
}
#set the ntp
function syncSystemTime(){
	echo ""
	echo "Set sync time..."
	yum -y install ntp > /dev/null 2>&1
	echo "01 01 * * * /usr/sbin/ntpdate ntp.api.bz    >> /dev/null 2>&1" >> /etc/crontab
	ntpdate ntp.api.bz
	service crond restart
}
#set the file limit
function openFiles(){
	echo ""
	echo "调整最大打开系统文件个数65535..."
	cp /etc/security/limits.conf /etc/security/limits.conf.`date +"%Y-%m-%d_%H:%M:%S"`
	ulimit -SHn 65535
	sed -i '/# End of file/i\*\t\t-\tnofile\t\t65535' /etc/security/limits.conf
	echo "ulimit -SHn 65535" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*                     soft     nofile             60000
*                     hard     nofile             65535
EOF
	echo -e "${GREEN_COLOR}Modify limits is succefful ---> (Restart to take effect)${RES}"
	sleep 1
}

#tune kernel parametres
function optimizationKernel(){
	echo ""
	echo "优化系统内核kernel..."
	cp /etc/sysctl.conf /etc/sysctl.conf.`date +"%Y-%m-%d_%H:%M:%S"` 
	cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
EOF
	/sbin/sysctl -p 
	[ $? -ne 0 ]&& action $"kernel youhua" /bin/true || action $"kernel youhua" /bin/false
}
#set the control-alt-delete to guard against the misuse
function initSafe(){
	echo ""
	echo "forbidden ctrl+alt+del..."
	cp /etc/inittab /etc/inittab.`date +"%Y-%m-%d_%H:%M:%S"`
	#sed -i 's@ca::ctrlaltdel:/sbin/shutdown -t3 -r now@#ca::ctrlaltdel:/sbin/shutdown -t3 -r now@' /etc/inittab
	sed -i 's@exec /sbin/shutdown -r now "Control-Alt-Delete pressed"@#exec /sbin/shutdown -r now "Control-Alt-Delete pressed"@' /etc/init/control-alt-delete.conf
	/sbin/init q
	[ $? -eq 0 ] && action $"forbid use ctrl+alt+del to reboot system" /bin/true || action $"forbid use ctrl+alt+del to reboot system" /bin/false
}
#disable ipv6
function disableIpv6(){
	echo ""
	echo "Disable ipv6..."
	echo "alias net-pf-10 off" >> /etc/modprobe.conf
	echo "alias ipv6 off" >> /etc/modprobe.conf
	echo "install ipv6 /bin/true" >> /etc/modprobe.conf
	cp /etc/sysconfig/network /etc/sysconfig/network.`date +"%Y-%m-%d_%H:%M:%S"`
	echo "IPV6INIT=no" >> /etc/sysconfig/network
	sed -i 's@NETWORKING_IPV6=yes@NETWORKING_IPV6=no@'    /etc/sysconfig/network
	chkconfig ip6tables off
}
#vim setting
function setVim(){
	echo ""
	echo "Set vim..."
cat >>~/.vimrc<<EOF
set ts=4
set shiftwidth=4
syntax on
set nohlsearch
EOF
#set ai
#set fencs=gb18030
#set autoindent
	echo -e "${GREEN_COLOR}Set vim ---> ok${RES}"
}

function initSnmp(){
	echo ""
	echo "Initialization snmp..."
	cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.`date +"%Y-%m-%d_%H:%M:%S"`
	sed -i 's@#view all@view all@' /etc/snmp/snmpd.conf
	sed -i 's@#access MyROGroup@access MyROGroup@' /etc/snmp/snmpd.conf
	${CHKCONFIG} snmpd on
	${SERVICE} snmpd start
	[ $? -eq 0 ] && action $"chushihua snmpd:" /bin/true || action $"chushihua snmpd:" /bin/false
}

#-------------------------------------------------------#
AStr="安装yum;设置字符编码;关闭防火墙、SELINUX;关闭不必要的服务"
BStr="安装系统工具gcc gcc-c++ vim-enhanced unzip unrar sysstat"
CStr="设置ssh，修改默认端口22->12321，禁止root登陆"
DStr="添加SA用户，设置sudo权限"
EStr="同步系统时间"
FStr="修改文件打开数"
GStr="优化系统内核"
HStr="关闭重启快捷键;关闭ipv6;set vim;set snmp"
IStr="一键初始化"

#-------------------------------------------------------#
echo "##################################################"
echo "#####################@初始化@#####################"
echo "A --${AStr}"
echo "B --${BStr}"
echo "C --${CStr}"
echo "D --${DStr}"
echo "E --${EStr}"
echo "F --${FStr}"
echo "G --${GStr}"
echo "H --${HStr}"
echo "I --${IStr}"
echo "##################################################"
echo "20s后将自动一键安装"

option="-1"
read -n1 -t20 -p "Choose one of A-I" option

flag1=$(echo $option | egrep "\-1" |wc -l)
flag2=$(echo $option | egrep "[a-kA-K]" |wc -l)

if [ $flag1 -eq 1 ];then
	option="I"
elif [ $flag2 -ne 1 ];then
	echo "请输入A->K的字母"
	exit 1
fi

echo -e "\nyour choose is: $option\n"
echo "after 5s start install...."
sleep 5

case $option in
	A|a)
		configYum
	        initI18n
        	initFirewall
		initService
	;;
	B|b)
		installTool
	;;
	C|c)
		initSsh
	;;
	D|d)
		addUser
	;;
	E|e)
		syncSystemTime
	;;
	F|f)
		openFiles
	;;
	G|g)
		optimizationKernel
	;;
	H|h)
		initSafe
                disableIpv6
		setVim
                #initSnmp
	;;
	I|i)
		configYum
		installTool
		initI18n
		initFirewall
		#initService
		initSsh
		addUser
		syncSystemTime
		openFiles
		optimizationKernel
		initSafe
		#disableIpv6
		setVim
		#initSnmp
	;;
	*)
		echo "Pls input A-K!"
		exit
	;;
esac

#reboot system
#reboot


