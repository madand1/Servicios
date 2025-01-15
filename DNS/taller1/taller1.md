# **Talleres DNS**

## Taller 1: Instalación y configuración del servidor bind9 en nuestra red local.

- He creado una máquina con un **Vagrantfile** y he instalado lo que es **bind9** esta en el siguiente [post](./Vagrantfile)

- Ahora lo qu ehice fue la siguiente configuración para que funciones como servidor, por lo que tenedremos que poner la siguinete edición en estos ficheros:

- Fichero ```/etc/default/named```
  - Contenido
```
#
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS="-4 -f -u bind"
```

- Ademas, tendremos que tener en cuenta que solo se permitirán consultas desde la red local. En caso de realizarlo con una VPN lo que tendremos que hacer es la modificación del siguinete fichero ```/etc/bind/named.conf.options```

Contenido del fichero:

```
vagrant@dns1:~$ cat /etc/bind/named.conf.options 
options {
    directory "/var/cache/bind";

    // Permitir consultas desde estas redes
    allow-query { 172.201.0.0/16; 172.22.0.0/16; };

    // Desactivar la validación DNSSEC
    dnssec-validation no;

    // Forwarders opcionales (puedes añadir servidores públicos como Google DNS)
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Configuración por defecto de BIND9
    auth-nxdomain no;    # Conform to RFC1035
    listen-on-v6 { any; };
};

```

- Reinicio el servidor, y realizo la siguiente consulsta desde la máquina DNS:


```
vagrant@dns1:~$ dig @172.22.200.100 www.josedomingo.org

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> @172.22.200.100 www.josedomingo.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30041
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 9ae8989b493ee0b80100000067876fa2526cd9910f831739 (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	900	IN	CNAME	endor.josedomingo.org.
endor.josedomingo.org.	900	IN	A	37.187.119.60

;; Query time: 231 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 08:19:46 UTC 2025
;; MSG SIZE  rcvd: 112
```

- ¿Cuánto ha tardado en realizar la consulta?
231 msec
- ¿Qué consultas se han realizado para averiguar la dirección IP?
La consulta es de tipo A y se ha realizado a la zona directa de josedomingo.org.
- Realizamos de nuevo la consulta. ¿Cuánto ha tardado ahora?
0 msec

```
vagrant@dns1:~$ dig @172.22.200.100 www.josedomingo.org

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> @172.22.200.100 www.josedomingo.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30041
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 9ae8989b493ee0b80100000067876fa2526cd9910f831739 (good)
;; QUESTION SECTION:
;www.josedomingo.org.		IN	A

;; ANSWER SECTION:
www.josedomingo.org.	900	IN	CNAME	endor.josedomingo.org.
endor.josedomingo.org.	900	IN	A	37.187.119.60

;; Query time: 0 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 08:19:46 UTC 2025
;; MSG SIZE  rcvd: 112
```

- ¿Por qué ha tardado menos?
Porque ya se ha realizado la consulta anteriormente y se ha guardado en el caché.
- ¿Qué consultas se han realizado para averiguar la dirección IP?
La consulta es de tipo A y se ha realizado a la zona directa de josedomingo.org.


Creamos una zona directa para nuestro dominio andres.org, añadiendo al fichero ```/etc/bind/named.conf.local```:

```
^Cvagrant@dns1:~cat /etc/bind/named.conf.local
include "/etc/bind/zones.rfc1918";

zone "andres.org" {
    type master;
    file "/var/cache/bind/db.andres.org";
};
```

- Creamos el fichero de la zona ``/var/cache/bind/db.andres.org`` y el fichero quedaría de la siguiente manera:

```
vagrant@dns1:~$ cat /var/cache/bind/db.andres.org 
$TTL    86400
@       IN      SOA     dns1.andres.org. root.andres.org. (
                            1         ; Serial
                       604800         ; Refresh
                        86400         ; Retry
                      2419200         ; Expire
                        86400 )       ; Negative Cache TTL
;
@	IN	NS		dns1.andres.org.
@	IN	MX	10	correo.andres.org.


dns1			IN	A	172.22.200.100
correo			IN	A	172.22.200.101
asterix		        IN	A	172.22.200.102
obelix			IN	A	172.22.200.103
www			IN	CNAME	asterix.andres.org.
informatica		IN	CNAME	asterix.andres.org.
ftp			IN	CNAME	obelix.andres.org.
```

- Creo una zona inversa, en el siguiente fichero ```/var/cache/bind/db.172.22.0.0```, cuyo contenido es el siguiente:

```
vagrant@dns1:~$ cat /var/cache/bind/db.172.22.0.0 
$TTL    86400
@       IN      SOA     dns1.andres.org. root.andres.org. (
                            1         ; Serial
                       604800         ; Refresh
                        86400         ; Retry
                      2419200         ; Expire
                        86400 )       ; Negative Cache TTL
;
@	IN	NS		dns1.andres.org.

; Registros PTR para la zona inversa
$ORIGIN 22.172.in-addr.arpa.
100.200         IN      PTR     dns1.andres.org.
101.200         IN      PTR     correo.andres.org.
102.200         IN      PTR     asterix.andres.org.
103.200         IN      PTR     obelix.andres.org.
```

Y descomentamos la línea include ````"/etc/bind/zones.rfc1918";```` para así incluir todas las zonas correspondientes a las redes privadas para que no se pregunten por ellas al servidor DNS raíz.

```
vagrant@dns1:~$ cat /etc/bind/named.conf.local 
include "/etc/bind/zones.rfc1918";

zone "andres.org" {
    type master;
    file "/var/cache/bind/db.andres.org";
};


zone "22.172.in-addr.arpa" {
    type master;
    file "db.172.22.0.0";
};

```

y comentamos la siguiente linea del siguiente fichero:

```
//zone "22.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
```
```
vagrant@dns1:~$ cat /etc/bind/zones.rfc1918 
zone "10.in-addr.arpa"      { type master; file "/etc/bind/db.empty"; };
 
zone "16.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "17.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "18.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "19.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "20.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "21.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
//zone "22.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "23.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "24.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "25.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "26.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "27.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "28.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "29.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "30.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "31.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };

zone "168.192.in-addr.arpa" { type master; file "/etc/bind/db.empty"; };

```

- Creamos el fichero /var/cache/bind/db.172.22.0.0:
```
vagrant@dns1:~$ cat /var/cache/bind/db.172.22.0.0 
$TTL    86400
@       IN      SOA     dns1.andres.org. root.andres.org. (
                            1         ; Serial
                       604800         ; Refresh
                        86400         ; Retry
                      2419200         ; Expire
                        86400 )       ; Negative Cache TTL
;
@	IN	NS		dns1.andres.org.

; Registros PTR para la zona inversa
$ORIGIN 22.172.in-addr.arpa.
100.200         IN      PTR     dns1.andres.org.
101.200         IN      PTR     correo.andres.org.
102.200         IN      PTR     asterix.andres.org.
103.200         IN      PTR     obelix.andres.org.

```

- Reinicia el sistema ```systemctl restart bind9```
- Incluimos en el fichero ```/etc/resolv.conf``` de nuestra máquina que actua como cliente, lo siguiente ```nameserver 172.22.200.100```, por lo que quedaría de la siguiente forma:

```
^Cmadandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/DNS/taller1$ 
cat /etc/resolv.conf
# Generated by NetworkManager
search gonzalonazareno.org 41011038.41.andared.ced.junta-andalucia.es
nameserver 172.22.200.100
nameserver 172.22.0.1
nameserver 192.168.0.1

```

Y ahora hacemos las comprobaciones:

- Dirección IP de una máquina o servicio.
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/DNS/taller1$ 
dig www.andres.org

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> www.andres.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21644
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 08305641e69030b201000000678798d348eebc4666960739 (good)
;; QUESTION SECTION:
;www.andres.org.			IN	A

;; ANSWER SECTION:
www.andres.org.		86400	IN	CNAME	asterix.andres.org.
asterix.andres.org.	86400	IN	A	172.22.200.102

;; Query time: 3 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 12:15:31 CET 2025
;; MSG SIZE  rcvd: 109

```
- Servidor DNS con autoridad de dominio.

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/DNS/taller1$ 
dig ns andres.org

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> ns andres.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12787
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: b6a63afe071f029601000000678799052ff4f135ef081c13 (good)
;; QUESTION SECTION:
;andres.org.			IN	NS

;; ANSWER SECTION:
andres.org.		86400	IN	NS	dns1.andres.org.

;; ADDITIONAL SECTION:
dns1.andres.org.	86400	IN	A	172.22.200.100

;; Query time: 3 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 12:16:21 CET 2025
;; MSG SIZE  rcvd: 102

```
- Servidor de correo del dominio.

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/DNS/taller1$ 
dig mx andres.org

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> mx andres.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54096
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: d65b86e17b0d4bef0100000067879922c8c6976b2a0350cb (good)
;; QUESTION SECTION:
;andres.org.			IN	MX

;; ANSWER SECTION:
andres.org.		86400	IN	MX	10 correo.andres.org.

;; ADDITIONAL SECTION:
correo.andres.org.	86400	IN	A	172.22.200.101

;; Query time: 0 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 12:16:50 CET 2025
;; MSG SIZE  rcvd: 106

```
- Una resolución inversa.
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/DNS/taller1$ 
dig -x 172.22.200.103

; <<>> DiG 9.18.28-1~deb12u2-Debian <<>> -x 172.22.200.103
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37048
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: c7907b39d25d0d1a010000006787992f0dfe504c04e87e2e (good)
;; QUESTION SECTION:
;103.200.22.172.in-addr.arpa.	IN	PTR

;; ANSWER SECTION:
103.200.22.172.in-addr.arpa. 86400 IN	PTR	obelix.andres.org.

;; Query time: 0 msec
;; SERVER: 172.22.200.100#53(172.22.200.100) (UDP)
;; WHEN: Wed Jan 15 12:17:03 CET 2025
;; MSG SIZE  rcvd: 115

```

## Taller 2: Instalación y configuración de un servidor DNS esclavo

Un servidor DNS esclavo contiene una réplica de las zonas del servidor maestro. Se debe producir una transferencia de zona (el esclavo hace una solicitud de la zona completa al maestro) para que se sincronicen los servidores. 

Antes que nada, cabe decir que el número de serie de la zona de transferencia tiene como función decirle al esclavo si la zona ha cambiado o no. Si el número de serie del esclavo es menor que el del maestro, el esclavo solicitará la zona al maestro. Si el número de serie del esclavo es mayor que el del maestro, el esclavo no solicitará la zona al maestro.

Los diferentes tiempos que se configuran enel registro SOA son:

- ``Refresh``: Tiempo que debe pasar antes de que el esclavo vuelva a consultar al maestro si la zona ha cambiado.
- ``Retry``: Tiempo que debe pasar antes de que el esclavo vuelva a consultar al maestro si la zona no ha cambiado.
- ``Expire``: Tiempo que debe pasar antes de que el esclavo considere que la zona ha expirado y la borre.
- ``Negative Cache TTL``: Tiempo que debe pasar antes de que el esclavo considere que la zona ha expirado.

1. Creamos otra máquina con vagrant cuyo rol será de Servidor DNS esclavo, al que le instalaremos bind9 y lo nombraremos con el nombre dns2.maria.org. La transferencia de zona entre maestro y esclavo usará el puerto 53/tcp, que abriremos en el grupo de seguridad.

