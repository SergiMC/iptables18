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
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -t nat -P DROP
iptables -t nat -P POSTROUTING DROP

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# obrir la nostra ip
iptables -A INPUT -s 192.168.2.40 -j ACCEPT
iptables -A OUTPUT -d 192.168.2.40 -j ACCEPT


# Consultem i obrim DNS PRIMARI
iptables -A INPUT -s 192.168.0.10 -p udp  -m udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.10 -p udp -m udp --dport 53 -j ACCEPT

# Consultem i obrim DNS SECUNDARI

iptables -A INPUT -s 10.1.1.200 -p udp  -m udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 10.1.1.200 -p udp -m udp --dport 53 -j ACCEPT

# Sincronitzem  el NTP (Network Time Protocol) amb enrutament (sistema de sicronització del rellotge del sistema).

iptables -A INPUT -p udp -m udp --sport 123 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --dport 123 -j ACCEPT

# Consultem CUPS (Sistema d'impresio)

iptables -A INPUT  -p tcp  --dport 631 -j ACCEPT
iptables -A OUTPUT -p tcp  --sport 631 -j ACCEPT

# Consultem servei xinetd

iptables -A INPUT  -p tcp  --dport 3411 -j ACCEPT
iptables -A OUTPUT -p tcp  --sport 3411 -j ACCEPT

# Consultem X11-FORWARD

iptables -A INPUT -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 6010 -j ACCEPT

#Consultem servei rpc (REMOTE PROCEDURE CALL)
#PERMET CONNEXIÓ D'UNA APP A UN HOST SENSE PREOCUPAR-SE DE LA COMUNICACIÓ

iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 111 -j ACCEPT

iptables -A INPUT -p tcp 
