#!/bin/bash
# @edt Sergi Muñoz Carmona ASIX M11-SAD
# Data: 12/04/2019 CURS 2018/2019
# iptables

#echo 1 > /proc/sys/ipv4/ip_forward (Ordre ja feta)

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

# Obrim la nostra ip
iptables -A INPUT -s 192.168.2.34 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.34 -j ACCEPT

#Fer NAT per la xarxa interna
iptables -t nat -A POSTROUTING -s 172.206.0.0/16 -o enp5s0 -j MASQUERADE

#S'habilita el port 3001 en endavant per accedir fent un telnet al port daytime del hostA
iptables -t nat -A PREROUTING -i enp5s0 -p tcp  --dport 3001 -j DNAT --to 172.206.0.2:13
#S'habilita el port 3001 en endavant per accedir fent un telnet  al port echo del hostB
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3002 -j DNAT --to 172.206.0.3:7

#DESDE L'EXTERIOR
#S'habilita el port 4001 en endavant per accedir per ssh al port ssh del hostA (EXTERIOR)
iptables -t nat -A PREROUTING -i enp5s0 -p tcp  --dport 4001 -j DNAT --to 172.206.0.2:22
#S'habilita el port 4002 en endavant per accedir per ssh al port ssh del hostB (EXTERIOR)
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4002 -j DNAT --to 172.206.0.3:22
#Habilitem el port 4000 en endavant per accedir per ssh al prot ssh del propi router (EXTERIOR)
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4000 -j DNAT --to :22

#DESDE INTERIOR
#Tot el tràfic que es destini al port 80 l'acceptarem i crearem una connexió establerta
iptables -A FORWARD -s 172.206.0.0/16 -p tcp --dport 80 -o enp5s0 -j ACCEPT
iptables -A FORWARD -d 172.206.0.0/16 -p tcp --sport 80 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 172.206.0.0/16 -p tcp --dport 442 -o enp5s0 -j ACCEPT
iptables -A FORWARD -d 172.206.0.0/16 -p tcp --sport 442  -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 172.206.0.0/16 -o enp5s0 -j REJECT 
iptables -A FORWARD -d 172.206.0.0/16 -i enp5s0 -j REJECT

#No permetre que la xarxa interna faci ping a l'exterior
iptables -A FORWARD -s 172.206.0.0/16  -o enp5s0 -p icmp --icmp-type 8 -j DROP

#No contestar als pings que rep el router
iptables -A OUTPUT -s 172.206.0.1/16 -p icmp --icmp-type 0 -j DROP


##################################################
#TOT EL QUE ENTRI AL PORT 80 de la maquina
#iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#TOT EL QUE SURTI DEL PORT 80
#iptables -A OUTPUT -p tcp --sport 80 -m state --state RELATED,ESTABLISHED  -j ACCEPT


#TOT EL QUE ENTRI/VINGUI D'UN PORT SOURCE 7
#iptables -A INPUT -p tcp --sport 7 -j ACCEPT
#TOT EL QUE SURTI I VA AL PORT DESTÍ
#iptables -A OUTPUT -p tcp --dport 7 -j ACCEPT

