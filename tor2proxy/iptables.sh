#!/bin/sh

### set variables
#destinations you don't want routed through Tor
_non_tor="192.168.1.0/24 192.168.0.0/24 172.0.0.0/8"

#the UID that Tor runs as (varies from system to system)
_tor_uid="$(ps -eo uid,gid,args | grep /usr/bin/tor | grep -v grep | awk '{print $1}')"

#Tor's TransPort
_trans_port="9040"

### Don't flush iptables
#iptables -F
#iptables -t nat -F

### set iptables *nat
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53

# Allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/9 127.128.0.0/10; do
   iptables -t nat -A OUTPUT -d $_clearnet -j RETURN
done

# Redirect all other output to Tor's TransPort
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port

### set iptables *filter
# The following are to prevent IP leak and should be the first rules in the output chain
iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
iptables -A OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP
# Allow existing connections 
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/8; do
   iptables -A OUTPUT -d $_clearnet -j ACCEPT
done

#allow only Tor output
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
iptables -A OUTPUT -j REJECT
