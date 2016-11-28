#!/bin/bash

#auth : by mean
#function : route

#以mac.txt文件定义的主机ip及mac地址来代替原有arp对应关系；每增加一台工作用机，就要重新运行一次此脚本。
echo "1" > /proc/sys/net/ipv4/ip_forward
arp -f /root/mac.txt

#清除本网关的Filter、FORWARD、POSTROUTIG链的默认规则
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
iptables -X -t mangle

modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat	#当iptables对filter nat mangle任意一表进行操作时，会自动加进iptable_nat模块；可以不写
modprobe ip_nat_ftp	#ip_nat_ftp是通过本机的FTP时需要用到
modprobe ip_nat_irc
modprobe ip_conntrack	#加载状态检测机制，state模块时用到，这个必写
#modprobe ip_conntrack_ftp	#ip_conntrack_ftp是本机做FTP时用到的，网关NAT用不用FTP决定加载否
#modprobe ip_conntrack_irc
#modprobe ips_MASQUERADE
#modprobe ips_state


#将FORWARD的默认策略设置为禁止一切(基于最安全原则考虑)
iptables -P FORWARD DROP

#客户机绑定mac地址才能上网，防止恶意增加IP在公司内部上网，不安全隐患。
cat /root/mac.txt | while read LINE
do
ipad=`echo $LINE | awk '{print $1}'`
macd=`echo $LINE | awk '{print $2}'`
iptables -A FORWARD -s $ipad -m mac --mac-source $macd -j ACCEPT
done

#网关上有两块网卡，eth0接的是外网IP地址，eth1对应该局域网IP，因是租用了电信的光纤，不存在着ADSL上网情况。
#Lan口:192.168.2.0/24 eth1
#Wan口:59.195.233.234/24 eth0
iptables -A FORWARD -i eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o eth1 -s 192.168.2.0/24 -j SNAT --to 59.195.233.234

#/root/mac.txt内容如下
function mactxt()
{
192.168.2.107 EC:88:8F:BD:6B:2A 
192.168.2.108 7C:DD:90:5D:6D:8F
192.168.2.112 38:59:F9:78:33:4B
}


