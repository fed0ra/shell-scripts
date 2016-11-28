#!/bin/bash

iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
iptables -X -t mangle

modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat
modprobe ip_nat_ftp
modprobe ip_nat_irc
#modprobe ip_conntrack
#modprobe ip_conntrack_ftp
#modprobe ip_conntrack_irc
#modprobe ips_MASQUERADE
#modprobe ips_state

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dport 80,22 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0  -j ACCEPT

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --sport 80,22 -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT


