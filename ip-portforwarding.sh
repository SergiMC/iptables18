#! /bin/bash
# @edt ASIX M11-SAD Curs 2018-2019
# iptables

#echo 1 > /proc/sys/ipv4/ip_forward

# Regles flush
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Polítiques per defecte: 
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# obrir la nostra ip
iptables -A INPUT -s 192.168.0.18 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.18 -j ACCEPT


#FER NAT PER LES XARXES INTERNES:
# 172.21.0.0/24
# 172.22.0.0/24
iptables -t nat -A POSTROUTING -s 172.21.0.0/24 -o enp5s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.23.0.0/24 -o enp5s0 -j MASQUERADE

#Exemples port forwarding
iptables -A INPUT -pt tcp --dport 13 -j REJECT # tot el tràfic input router xapa'l #FUNCIONARÀ 5003 NOMÈS
#iptables -A FORWARD -p tcp --dport 13 -j REJECT # tot el trafic que es destini al port 13 de creuament xapa'l. #FUNCIONARÀ 5001 5002 
iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT --to 172.21.0.2:13
iptables -t nat -A PREROUTING -p tcp --dport 5002 -j DNAT --to 172.21.0.3:13
iptables -t nat -A PREROUTING -p tcp --dport 5003 -j DNAT --to 192.168.2.40:13
