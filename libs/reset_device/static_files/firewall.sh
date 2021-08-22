#!/bin/bash

#IPTABLES=/sbin/iptables


sudo iptables -N internet -t mangle

sudo iptables -t mangle -A PREROUTING -j internet

sudo iptables -t mangle -A internet -j MARK --set-mark 99

sudo iptables -t nat -A PREROUTING -m mark --mark 99 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1 #adjusted for my IP address

#$IPTABLES -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
#$IPTABLES -t filter -A INPUT -p udp --dport 53 -j ACCEPT
#$IPTABLES -t filter -A INPUT -m mark --mark 99 -j DROP

echo "1" > /proc/sys/net/ipv4/ip_forward

sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -m mark --mark 99 -j REJECT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

#from https://raw.githubusercontent.com/AloysAugustin/captive_portal/master/firewall.sh