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

# Consultem CUPS (Sistema d'impresio) (obrim)

iptables -A INPUT  -p tcp  --dport 631 -j ACCEPT
iptables -A OUTPUT -p tcp  --sport 631 -j ACCEPT

# Consultem servei xinetd (obrim)

iptables -A INPUT  -p tcp  --dport 3411 -j ACCEPT
iptables -A OUTPUT -p tcp  --sport 3411 -j ACCEPT

# Consultem X11-FORWARD (obrim)

iptables -A INPUT -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 6010 -j ACCEPT

#Consultem servei rpc (REMOTE PROCEDURE CALL) (obrim)
#PERMET CONNEXIÓ D'UNA APP A UN HOST SENSE PREOCUPAR-SE DE LA COMUNICACIÓ

iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 111 -j ACCEPT

# Consultem icmp (Linux IPv4 ICMP kernel module) (obrim)

iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# Consultem servei ssh (obrim)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

#Consultem servei http (obrim) 
#TOT EL QUE ENTRI QUE VINGUI DEL PORT  80
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -m   -j ACCEPT

#Consultem servei smtp (obrim)

iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT

#Consultem servei echo (obrim)

iptables -A INPUT -p tcp --dport 7 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 7 -j ACCEPT

#Consultem servei daytime (obrim)
iptables -A INPUT -p tcp --dport 13 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 13 -j ACCEPT


