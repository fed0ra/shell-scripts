#!/bin/bash

# 防止SSH暴利破解,Iptables_recent模块_限制单位时间内SSH连接数
iptables -I INPUT -p tcp --dport 80 -m state --state NEW -m recent --name web --set
iptables -A INPUT -m recent --update --name web --seconds 60 --hitcount 20 -j LOG --log-prefix 'HTTP attack:'
iptables -A INPUT -m recent --update --name web --seconds 60 --hitcount 20 -j DROP



