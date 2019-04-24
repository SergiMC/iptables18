**Sergi Muñoz Carmona**
**Iptables**


**Practica a l'aula**

Configurar físicament a l'aula una xarxa privada interna amb dos hosts i un tercer que faci de router 
que connecti a la xarxa de l'aula (i a internet). Posar serveis als dos hosts i configurar el firewall del router:

* (1) el router fa NAT de la xarxa interna

```
iptables -t nat -A POSTROUTING -s 172.206.0.0/16 -o enp5s0 -j MASQUERADE
```


* (2) en el router el port 3001 porta a un servei del host1 i el port 3002 a un servei del host2.
**Tot el que entri per l'interfície enp5s0 qur vingui del port 3001 que l'envii al port 13 del hostA**
**Tot el que entri per l'interfície enp5s0 qur vingui del port 3002 que l'envii al port 7 del hostA**
```
#S'habilita el port 3001 en endavant per accedir per daytime al port daytime del hostA
iptables -t nat -A PREROUTING -i enp5s0 -p tcp  --dport 3001 -j DNAT --to 172.206.0.2:13

#S'habilita el port 3001 en endavant per accedir per echo al port  echo del hostB
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 3002 -j DNAT --to 172.206.0.3:7
```
* Resultat: 
-En el hostA fem:
```
telnet 172.206.0.1 3001
```
-En el hostB fem:
```
telnet 172.206.0.1 3002
```
	    
* (3) en el router el port 4001 porta al servei ssh del hostA i el port 4002 al servei ssh del hostB.

**Tot el que entri per l'interfície enp5s0 i vagi al port 4001 redireccionarà al port 22 del hostA.**
**Tot el que entri per l'interfície enp5s0 i vagi al port 4002 redireccionarà al port 22 del hostB.**
```
#S'habilita el port 4001 en endavant per accedir per ssh al port ssh del hostA
iptables -t nat -A PREROUTING -i enp5s0 -p tcp  --dport 4001 -j DNAT --to 172.206.0.2:22
#S'habilita el port 4002 en endavant per accedir per ssh al port ssh del hostB
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4002 -j DNAT --to 172.206.0.3:22
```
**EN UN HOST EXTERN ENTREM ALS 2 HOSTS I ROUTER:**
```
[root@i22 ~]# ssh root@i04 -p 4001
root@i04's password: 
"System is booting up. See pam_nologin(8)"
Last login: Fri Apr 12 11:34:38 2019 from 192.168.2.52

[root@i22 ~]# ssh root@i04 -p 4002
The authenticity of host '[i04]:4002 ([192.168.2.34]:4002)' can't be established.
ECDSA key fingerprint is SHA256:ewa+tleb+orAdIlpqCUss/YWnjfX5KN7trkaI6HBwqM.
ECDSA key fingerprint is MD5:a1:6e:e6:76:04:0f:d8:f3:54:87:fe:9c:d2:84:81:9a.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[i04]:4002,[192.168.2.34]:4002' (ECDSA) to the list of known hosts.
root@i04's password: 
"System is booting up. See pam_nologin(8)"
Last login: Fri Apr 12 09:34:38 2019

[root@i22 ~]# ssh root@i04 -p 4000
The authenticity of host '[i04]:4000 ([192.168.2.34]:4000)' can't be established.
ECDSA key fingerprint is SHA256:zSqBKajtZE5kXnapbKEgy6RvGA8j2XvLu1MuJX92Hno.
ECDSA key fingerprint is MD5:d0:3b:b5:c6:f3:c7:ba:62:2a:f3:94:fc:41:d7:e5:f1.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[i04]:4000,[192.168.2.34]:4000' (ECDSA) to the list of known hosts.
root@i04's password: 
Last login: Fri Apr 12 09:42:06 2019


```

* (4) en el router el port 4000 porta al servei ssh del propi router.

**Tot el que entri per l'interfície enp5s0 i vagi al port 4000 redireccionarà al port 22 del propi router.**
```
iptables -t nat -A PREROUTING -i enp5s0 -p tcp --dport 4000 -j DNAT --to :22
```
* (5) als hosts de la xarxa privada interna se'ls permet navegar per internet, però no cap altre accés a internet.
** Fem Forward a travès de la xarxa, pel port 80 i que surti per la interifice , l'acceptem**
** Tot el faci forward, que entri per l'interficie enp5s0 i sigui del port 80 on el destí es la xarxa privada, l'acceptem
** Tot de la xarxa interna que surti per la enp5s0 xapem**
** Tot de la xarxa interna que rep a través de la interifice, xapem**
```
iptables -A FORWARD -s 172.206.0.0/16 -p tcp --dport 80 -o enp5s0 -j ACCEPT
iptables -A FORWARD -d 172.206.0.0/16 -p tcp --sport 80 -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 172.206.0.0/16 -p tcp --dport 442 -o enp5s0 -j ACCEPT
iptables -A FORWARD -d 172.206.0.0/16 -p tcp --sport 442  -i enp5s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 172.206.0.0/16 -o enp5s0 -j REJECT 
iptables -A FORWARD -d 172.206.0.0/16 -i enp5s0 -j REJECT
```
* (6) no es permet que els hosts de la xarxa interna facin ping a l'exterior.

**Desde la xarxa 172.206.0.0 per la sortida de la interifice enp5s0 xapem els pings.**
** Tot el ping de la xarxa 172.206.0.0/16 que surti per enp5s0 no es permet. 

```
iptables -A FORWARD -s 172.206.0.0/16  -o enp5s0 -p icmp --icmp-type 8 -j DROP

```
**HOST B**
NO FA PING! CORRECTE!

**HOST A**
NO FA PING! CORRECTE!

* (7) el router no contesta als pings que rep, però si que pot fer ping.

**La sortida del ping del router la xapem**
**Tot el tràfic que surt de la xarxa 172.206.0.1 (en aquest cas el ping) el xapem.**
```
iptables -A OUTPUT -s 172.206.0.1/16 -p icmp --icmp-type 0 -j DROP

```

**HOST B**
NO FA PING! CORRECTE

#ROUTER: PERMET FER PING!
[root@i04 iptables18]# ping 172.206.0.2
PING 172.206.0.2 (172.206.0.2) 56(84) bytes of data.
64 bytes from 172.206.0.2: icmp_seq=1 ttl=64 time=0.374 ms
64 bytes from 172.206.0.2: icmp_seq=2 ttl=64 time=0.481 ms
^C
