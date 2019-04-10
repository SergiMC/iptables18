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
iptables -A INPUT -s 192.168.2.40 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.40 -j ACCEPT


#FER NAT PER LES XARXES INTERNES:
# 172.21.0.0/24
# 172.22.0.0/24
iptables -t nat -A POSTROUTING -s 172.21.0.0/24 -o enp5s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.23.0.0/24 -o enp5s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.24.0.0/24 -o enp5s0 -j MASQUERADE
#Exemples port forwarding
#iptables -A INPUT -pt tcp --dport 13 -j REJECT # tot el tràfic input router xapa'l #FUNCIONARÀ 5003 NOMÈS
#iptables -A FORWARD -p tcp --dport 13 -j REJECT # tot el trafic que es destini al port 13 de creuament xapa'l. #FUNCIONARÀ 5001 5002 
#iptables -t nat -A PREROUTING -p tcp --dport 5001 -j DNAT --to 172.21.0.2:13
#iptables -t nat -A PREROUTING -p tcp --dport 5002 -j DNAT --to 172.21.0.3:13
#iptables -t nat -A PREROUTING -p tcp --dport 5003 -j DNAT --to 192.168.2.40:13
###########################################
#EXEMPLES CLASSE:
#Pel prot 6001 anirem a parar al port 80 del docker A1
#iptables -t nat -A PREROUTING -p tcp --dport 6001 -j DNAT --to 172.21.0.2:80
#Pel port 6002 anirem a parar al port 80 de l'escola del treball
#iptables -t nat -A PREROUTING -p tcp --dport 6002 -j DNAT --to 10.1.10:80
#Pel port 6000 anirem al nostre port 22 (nomès nosaltres)
#iptables -t nat -A PREROUTING -p tcp -s 192.168.2.40 --dport 6000 -j DNAT --to :22
#########
#tot allo que entra per la interficie 172... pel port 25, anirà destinat al port 25 del local
#iptables -t nat -A PREROUTING -s 172.21.0.0/24 -p tcp --dport 25 -j DNAT --to 192.168.2.40:25
#iptables -t nat -A PREROUTING -s 172.23.0.0/24 -p tcp --dport 25 -j DNAT --to 192.168.2.40:25

#Quan volem entrar al marca/liga, sortirà el server web de l'escola del treball
#iptables -t nat -A PREROUTING -s 172.21.0.0/24 -p tcp --dport 80 -j DNAT -to 10.1.1.8:80
#iptables -t nat -A PREROUTING -s 172.23.0.0/24 -p tcp --dport 80 -j DNAT -to 10.1.1.8:80
#####################################################################
#PRÀCTICA
#####################################################################
#de la xarxaA només es pot accedir ,del router/firewall ,als serveis: ssh i daytime(13)
#iptables -A INPUT -s 172.21.0.0/24 -p tcp --dport 22 -j ACCEPT 
#iptables -A INPUT -s 172.21.0.0/24 -p tcp --dport 13 -j ACCEPT

#de la xarxaA només es pot accedir a l'exterior als serveis web, ssh i daytime(2013)
#iptables -A FORWARD  -s 172.21.0.0/24 -p tcp --dport 80 -o enp5s0   -j ACCEPT
#iptables -A FORWARD  -d 172.21.0.0/24 -p tcp --sport 80 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD  -s 172.21.0.0/24 -p tcp --dport 22 -o enp5s0   -j ACCEPT
#iptables -A FORWARD  -d 172.21.0.0/24 -p tcp --sport 22 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD  -s 172.21.0.0/24 -p tcp --dport 2013 -o enp5s0   -j ACCEPT
#iptables -A FORWARD  -d 172.21.0.0/24 -p tcp --sport 2013 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD  -s 172.21.0.0/24 -o enp5s0 -j REJECT 
#iptables -A FORWARD  -d 172.21.0.0/24 -i enp5s0 -j REJECT 
#de la xarxaA només es pot accedir serveis que ofereix la DMZ al servei web
iptables -A FORWARD -s 172.21.0.0/24 -d 172.24.0.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 172.21.0.0/24 -d 172.24.0.0/24 -j REJECT
#redirigir els ports perquè des de l'exterior es tingui accés a: 3001->hostA1:80, 3002->hostA2:2013, 3003->hostB1:2080,3004->hostB2:2007
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3001 -j DNAT --to 172.21.0.2:80
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3002 -j DNAT --to 172.21.0.3:2013
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3003 -j DNAT --to 172.23.0.2:2080
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3004 -j DNAT --to 172.23.0.3:7
#S'habiliten els ports 4001 en endavant per accedir per ssh als ports ssh de: hostA1, hostA2, hostB1, hostB2.
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4001 -j DNAT --to 172.21.0.2:22
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4002 -j DNAT --to 172.21.0.3:22
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4003 -j DNAT --to 172.23.0.2:22
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4004 -j DNAT --to 172.23.0.3:22
#S'habilita el port 4000 per accedir al port ssh del router/firewal si la ip origen és del host i11.
iptables -t nat -A PREROUTING -s 192.168.2.41 -p tcp --dport 4000 -j DNAT --to 192.168.2.40:22
#Els hosts de la xarxaB tenen accés a tot arreu excepte a la xarxaA.
iptables -A FORWARD -s 172.23.0.0/24 -d 172.21.0.0/24 -j REJECT
iptables -A FORWARD -s 172.23.0.0/24 -j ACCEPT

#MOURE ELS PREROUTING ABANS DE 
#iptables -A FORWARD  -s 172.21.0.0/24 -o enp5s0 -j REJECT
#iptables -A FORWARD  -d 172.21.0.0/24 -i enp5s0 -j REJECT








