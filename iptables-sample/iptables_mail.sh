#!/bin/bash

iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -t mangle -X

modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat
modprobe ip_nat_ftp
modprobe ip_nat_irc

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -s 192.168.2.99 -j ACCEPT

iptables -N synflood
iptables -A synflood -m limit --limit 10/s --limit-burst 100 -j RETURN
iptables -A synflood -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp -m state --state NEW -j synflood
iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j DROP

iptables -A INPUT -p tcp -m multiport --dport 80,22 -j ACCEPT
