# iptables
## @ edt ASIX M11-SAD Curs 2018-2019

Exemples  d'iptables

 * **ip-default.sh**

   Accions bàsiques de configuració d'un script de iptables:
   * Esborar les regles (flush)  i comptadors actuals
   * Regles per defecte
   * Obrir la connectivitat pròpia al loopback i a la propia adreça ip
   * Definir si el host fa de router

 * **ip-basic-01.sh** 

    Regles INPUT.

    Exemples bàsics de filtrats INPUT. Jugant amb el port 80
    s'han redefinit ports alternatius on aplicar regles de filtrat d'entrada. 
    Les clàssiques regles
    * Port obert a tothom
    * Port tancat a tothom amb reject
    * Port tancat a tothom amb drop
    * Port tancat a tothom excepte hostA
    * Port obert a tothom excepte hostA
    * Port tancat a tothom excepte xarxaA (obert), però no al seu hostA (tancat)
    * Port obert a tothom excepte xarxaA (tancat), però no al seu hostA (obert)
    * Port obert per defecte, tancat a la xarxaA i obert als seus hosts hostA, hostB i hostC
 
    * barrera per defcete: tancar els altrs ports

 * **ip-basic-02.sh**

    Regles OUTPUT.

    Exemples bàsics de filtrats OUTPUT. Jugant amb el port 13
    s'han redefinit ports alternatius on aplicar regles de filtrat de sortida.
    Les clàssiques regles
    * Accedir a qualsevol port/destí
    * Accedir al portA de qualsevol destí
    * Accés permès al portA a qualsevol destí excepte hostA (denegat)
    * Accés denegat al portA a qualsevol destó  excepte hostA (permès)
    * Accés permès al portA a qualsevol destí excepte xarxaA (denegat)
    * Accés denegat al portA a qualsevol destí excepte xarxaA (permès)
    * Accés permès al portA a qualsevol destí, excepte de xarxaA (denegat)
      exceptuant hostA (permès)
    * Accés denegat al portA a qualsevol destí, excepte xarxaA (permès) 
      exceptuant hostA (denegat)
    * Denegat l'accés als ports externs 80, 13 i 7.
    * Denegat qualsevol tipus d'accés a les xarxes destí xarxaA i xarxaB
    * Denegat qualsevol tipus d'accés als hosts hostA, hostB i hostC
    * Denegat qualsevol accés extern a la xarxaA excepte si és per ssh.

 * **ip-basix-03.sh**

    tràfic related de tornada, tràfic related de sortida.


 * icmp
 * forward
 * port/host forwarding
 * nat
 * dnat, snat. prerouting, postrouting
 * DMZ
 *  firewalld



