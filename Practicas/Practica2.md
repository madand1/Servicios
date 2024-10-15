# Servidor DHCP

1. Entrar en lo que seria nuestro contenedor
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorDHCP

2. Descargar e nnstalar el servidor dhcp:

root@servidorDHCP:/# apt-get install isc-dhcp-server
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  isc-dhcp-common policycoreutils selinux-utils
Paquetes sugeridos:
  policykit-1 isc-dhcp-server-ldap ieee-data
Se instalarán los siguientes paquetes NUEVOS:
  isc-dhcp-common isc-dhcp-server policycoreutils selinux-utils
0 actualizados, 4 nuevos se instalarán, 0 para eliminar y 2 no actualizados.
Se necesita descargar 1.884 kB de archivos.
Se utilizarán 7.943 kB de espacio de disco adicional después de esta operación.
¿Desea continuar? [S/n] s
Des:1 http://deb.debian.org/debian bookworm/main amd64 isc-dhcp-common amd64 4.4.3-P1-2 [117 kB]
Des:2 http://deb.debian.org/debian bookworm/main amd64 isc-dhcp-server amd64 4.4.3-P1-2 [1.479 kB]
Des:3 http://deb.debian.org/debian bookworm/main amd64 selinux-utils amd64 3.4-1+b6 [126 kB]
Des:4 http://deb.debian.org/debian bookworm/main amd64 policycoreutils amd64 3.4-1 [161 kB]
Descargados 1.884 kB en 2s (938 kB/s)    
debconf: delaying package configuration, since apt-utils is not installed
Seleccionando el paquete isc-dhcp-common previamente no seleccionado.
(Leyendo la base de datos ... 9290 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../isc-dhcp-common_4.4.3-P1-2_amd64.deb ...
Desempaquetando isc-dhcp-common (4.4.3-P1-2) ...
Seleccionando el paquete isc-dhcp-server previamente no seleccionado.
Preparando para desempaquetar .../isc-dhcp-server_4.4.3-P1-2_amd64.deb ...
Desempaquetando isc-dhcp-server (4.4.3-P1-2) ...
Seleccionando el paquete selinux-utils previamente no seleccionado.
Preparando para desempaquetar .../selinux-utils_3.4-1+b6_amd64.deb ...
Desempaquetando selinux-utils (3.4-1+b6) ...
Seleccionando el paquete policycoreutils previamente no seleccionado.
Preparando para desempaquetar .../policycoreutils_3.4-1_amd64.deb ...
Desempaquetando policycoreutils (3.4-1) ...
Configurando selinux-utils (3.4-1+b6) ...
Configurando policycoreutils (3.4-1) ...
Configurando isc-dhcp-server (4.4.3-P1-2) ...
Generating /etc/default/isc-dhcp-server...
Job for isc-dhcp-server.service failed because the control process exited with error code.
See "systemctl status isc-dhcp-server.service" and "journalctl -xeu isc-dhcp-server.service" for details.
invoke-rc.d: initscript isc-dhcp-server, action "start" failed.
× isc-dhcp-server.service - LSB: DHCP server
     Loaded: loaded (/etc/init.d/isc-dhcp-server; generated)
     Active: failed (Result: exit-code) since Wed 2024-10-09 08:34:57 CEST; 13ms ago
       Docs: man:systemd-sysv-generator(8)
    Process: 268 ExecStart=/etc/init.d/isc-dhcp-server start (code=exited, status=1/FAILURE)
        CPU: 20ms

oct 09 08:34:55 servidorDHCP dhcpd[280]: bugs on either our web page at www.isc.org or in the README file
oct 09 08:34:55 servidorDHCP dhcpd[280]: before submitting a bug.  These pages explain the proper
oct 09 08:34:55 servidorDHCP dhcpd[280]: process and the information we find helpful for debugging.
oct 09 08:34:55 servidorDHCP dhcpd[280]: 
oct 09 08:34:55 servidorDHCP dhcpd[280]: exiting.
oct 09 08:34:57 servidorDHCP isc-dhcp-server[268]: Starting ISC DHCPv4 server: dhcpdcheck syslog for diagnostics. ... failed!
oct 09 08:34:57 servidorDHCP isc-dhcp-server[268]:  failed!
oct 09 08:34:57 servidorDHCP systemd[1]: isc-dhcp-server.service: Control process exited, code=exited, status=1/FAILURE
oct 09 08:34:57 servidorDHCP systemd[1]: isc-dhcp-server.service: Failed with result 'exit-code'.
oct 09 08:34:57 servidorDHCP systemd[1]: Failed to start isc-dhcp-server.service - LSB: DHCP server.
Configurando isc-dhcp-common (4.4.3-P1-2) ...

 
3. Configuraremos la interfaz del servidor DHCP
   
Esto sera en el archivo de configuracion *nano /etc/default/isc-dhcp-server* y buscamos la linea que pone *INTERFACESv4=""* y cambiamos el valor POR TU TARJETA DE RED, en mi caso es eth0, con lo que quedaria asi:

```INTERFACESv4="eth0"```

4. Configuramos el rango de direcciones IP, y todo lo que nos pide.

En el fichero *nano /etc/dhcp/dhcpd.conf* y le agregamos esta confirguacion:

```
# Configuración del DHCP
default-lease-time 1800;  # 30 minutos
max-lease-time 1800;      # 30 minutos

subnet 192.168.200.0 netmask 255.255.255.0 {
    range 192.168.200.10 192.168.200.200;   # Rango de direcciones IP
    option routers 192.168.200.1;           # Puerta de enlace predeterminada
    option subnet-mask 255.255.255.0;       # Máscara de red
    option domain-name-servers 172.22.0.1;  # Servidor DNS
}
```

5. Reiniciamos el servidor DHCP

```sudo systemctl restart isc-dhcp-server```

6. Verificamos el estado del servicio DHCP

```sudo systemctl status isc-dhcp-server```

Y nos saldra lo siguiente:

```
root@servidorDHCP:/# systemctl status isc-dhcp-server
● isc-dhcp-server.service - LSB: DHCP server
     Loaded: loaded (/etc/init.d/isc-dhcp-server; generated)
     Active: active (running) since Wed 2024-10-09 08:43:38 CEST; 12s ago
       Docs: man:systemd-sysv-generator(8)
    Process: 463 ExecStart=/etc/init.d/isc-dhcp-server start (code=exited, status=0/SUCCESS)
      Tasks: 1 (limit: 18748)
     Memory: 4.6M
        CPU: 43ms
     CGroup: /system.slice/isc-dhcp-server.service
             └─475 /usr/sbin/dhcpd -4 -q -cf /etc/dhcp/dhcpd.conf eth0

oct 09 08:43:36 servidorDHCP systemd[1]: Starting isc-dhcp-server.service - LSB: DHCP server...
oct 09 08:43:36 servidorDHCP isc-dhcp-server[463]: Launching IPv4 server only.
oct 09 08:43:36 servidorDHCP dhcpd[475]: Wrote 0 leases to leases file.
oct 09 08:43:36 servidorDHCP dhcpd[475]: Server starting service.
oct 09 08:43:38 servidorDHCP isc-dhcp-server[463]: Starting ISC DHCPv4 server: dhcpd.
oct 09 08:43:38 servidorDHCP systemd[1]: Started isc-dhcp-server.service - LSB: DHCP server.

```
7. Cambio a DHCP del cliente 1

Antes teniamos la ip estatica la cual era 192.168.200.13/24 ahora se le ha asignado 192.168.200.10/24, esto se ve asi:

![cliente_dhcp](/img/dhcp-client1.png)

Para ello lo que hemos hecho ha sido lo siguiente:

- Meternos en el fichero de configuración de las redes:

```sudo nano /etc/network/interfaces```

- Configurar la interfaz de red:

```
auto enp7s0
iface enp7s0 inet dhcp
```

Y vemos como se da con la imagen de arriba

8. Creacion del cliente con windows 10

9. Conecta una máquina Windows a la red_intra y comprueba que también toma direccionamiento dinámico.

<<<<<<< HEAD
![cliente_dhcp](/img/dhcp-w10.png)
=======
![clientedhcp](/img/dhcp-w10.png)
>>>>>>> 980ca238cd9db03f51ecf40de32b697dd6c7bbfe

10. Realizar una captura, desde el servidor usando tcpdump, de los cuatro paquetes que corresponden a una concesión: DISCOVER, OFFER, REQUEST, ACK

```tcpdump -i eth0 -n -vv udp port 67 or port 68```

```
root@servidorDHCP:/# tcpdump -i eth0 -n -vv udp port 67 or port 68
tcpdump: listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
08:55:23.352584 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 329)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from 52:54:00:56:fa:0b, length 301, xid 0xe2b66b37, Flags [none] (0x0000)
	  Client-Ethernet-Address 52:54:00:56:fa:0b
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Discover
	    Requested-IP (50), length 4: 192.168.200.10
	    Hostname (12), length 13: "Cliente1-andy"
	    Parameter-Request (55), length 13: 
	      Subnet-Mask (1), BR (28), Time-Zone (2), Default-Gateway (3)
	      Domain-Name (15), Domain-Name-Server (6), Unknown (119), Hostname (12)
	      Netbios-Name-Server (44), Netbios-Scope (47), MTU (26), Classless-Static-Route (121)
	      NTP (42)
	    Client-ID (61), length 19: hardware-type 255, 00:56:fa:0b:00:01:00:01:2e:98:f3:6f:52:54:00:56:fa:0b
08:55:24.353885 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    192.168.200.3.67 > 192.168.200.10.68: [udp sum ok] BOOTP/DHCP, Reply, length 300, xid 0xe2b66b37, Flags [none] (0x0000)
	  Your-IP 192.168.200.10
	  Client-Ethernet-Address 52:54:00:56:fa:0b
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Offer
	    Server-ID (54), length 4: 192.168.200.3
	    Lease-Time (51), length 4: 1800
	    Subnet-Mask (1), length 4: 255.255.255.0
	    Default-Gateway (3), length 4: 192.168.200.1
	    Domain-Name (15), length 11: "example.org"
	    Domain-Name-Server (6), length 4: 172.22.0.1
08:55:24.355438 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 335)
    0.0.0.0.68 > 255.255.255.255.67: [udp sum ok] BOOTP/DHCP, Request from 52:54:00:56:fa:0b, length 307, xid 0xe2b66b37, Flags [none] (0x0000)
	  Client-Ethernet-Address 52:54:00:56:fa:0b
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: Request
	    Server-ID (54), length 4: 192.168.200.3
	    Requested-IP (50), length 4: 192.168.200.10
	    Hostname (12), length 13: "Cliente1-andy"
	    Parameter-Request (55), length 13: 
	      Subnet-Mask (1), BR (28), Time-Zone (2), Default-Gateway (3)
	      Domain-Name (15), Domain-Name-Server (6), Unknown (119), Hostname (12)
	      Netbios-Name-Server (44), Netbios-Scope (47), MTU (26), Classless-Static-Route (121)
	      NTP (42)
	    Client-ID (61), length 19: hardware-type 255, 00:56:fa:0b:00:01:00:01:2e:98:f3:6f:52:54:00:56:fa:0b
08:55:24.358950 IP (tos 0x10, ttl 128, id 0, offset 0, flags [none], proto UDP (17), length 328)
    192.168.200.3.67 > 192.168.200.10.68: [udp sum ok] BOOTP/DHCP, Reply, length 300, xid 0xe2b66b37, Flags [none] (0x0000)
	  Your-IP 192.168.200.10
	  Client-Ethernet-Address 52:54:00:56:fa:0b
	  Vendor-rfc1048 Extensions
	    Magic Cookie 0x63825363
	    DHCP-Message (53), length 1: ACK
	    Server-ID (54), length 4: 192.168.200.3
	    Lease-Time (51), length 4: 1800
	    Subnet-Mask (1), length 4: 255.255.255.0
	    Default-Gateway (3), length 4: 192.168.200.1
	    Domain-Name (15), length 11: "example.org"
	    Domain-Name-Server (6), length 4: 172.22.0.1

4 packets captured
4 packets received by filter
0 packets dropped by kernel

```

11. Cambio de tiempo de concesion en el servidor DHCP:

ESTO SON 10 SEGUNDOS

default-lease-time 10;
max-lease-time 10;

Ahora lo que haremos sera hacer un restart del dhcp : *systemctl restart isc-dhcp-server* para que coja la configuracion que le dimos.

Vemos como tenemos la ip asignada por dhcp tanto en el cliente windows y linux.

![cliente_dhcp](/img/ip-dhcp-antes.png)

Y ahora hacemos un systemctl stop isc-dhcp-server, y nos ocurre que el cliente windows pilla la dirección de la pipa y el cliente linux se nos queda sin dirección ip.

![cliente_dhcp](/img/dhcp-despues.png)

12. Cambiamos lo que va siendo el rango de ips, y estas nos hanj cogido las qu eestan denrtro del rango.

```
root@servidorDHCP:/# nano /etc/dhcp/dhcpd.conf
root@servidorDHCP:/# systemctl restart isc-dhcp-server
root@servidorDHCP:/# 

```

13. Actualmente los servidores servidorWeb y servidorNAS tienen una configuración de red estática. Vamos a configurar una reserva para cada máquina. Configura de forma adecuada el servidor dhcp para que ofrezca a estos servidores la misma IP (reserva) que habíamos configurado de forma estática.

```
root@servidorDHCP:/# nano /etc/dhcp/dhcpd.conf

.......
......
......
# Reservas

# Reserva para el servidorWeb
host servidorWeb {
    hardware ethernet 00:16:3e:9a:f5:61;
    fixed-address 192.168.200.33;
}

# Reserva para el servidorNAS
host servidorNAS {
    hardware ethernet 52:54:00:f0:ba:36;
    fixed-address 192.168.200.56;
}

.....
....
....
```

14. Modifica la configuración de red del servidorWeb y el servidorNAS para que tomen la configuración de red de forma dinámica.

```
madandy@toyota-hilux:~$ ssh servidorNAS 
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

nas-andy:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:f0:ba:36 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.56/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fef0:ba36/64 scope link 
       valid_lft forever preferred_lft forever
nas-andy:~$ 
```

```
madandy@toyota-hilux:~$ ssh servidorWeb 
The authenticity of host '192.168.200.33 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:1rSnmoqJXlY0mnVd7aGFe/U5PgM4FE4S/dGu1HC3Nr4.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:54: [hashed name]
    ~/.ssh/known_hosts:60: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.200.33' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.1.0-26-amd64 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro
Last login: Fri Oct  4 12:18:02 2024 from 192.168.200.1
root@servidorWeb:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:9a:f5:61 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.33/24 metric 100 brd 192.168.200.255 scope global dynamic eth0
       valid_lft 8sec preferred_lft 8sec
    inet6 fe80::216:3eff:fe9a:f561/64 scope link 
       valid_lft forever preferred_lft forever
root@servidorWeb:~# 
```


Para esta parte:


fichero de configuracin:

```
madandy@toyota-hilux:~$ cat .ssh/config 
Host router
  HostName  172.22.3.69
  User user 
  ForwardAgent yes


Host servidorNAS
  HostName 192.168.200.56
  User user
  ForwardAgent yes
  ProxyJump router

Host servidorDHCP
  HostName 192.168.200.3
  User root
  ForwardAgent yes
  ProxyJump router

Host servidorWeb
  HostName 192.168.200.33
  User root
  ForwardAgent yes
  ProxyJump router


Host cliente1
  HostName 192.168.200.13
  User debian
  ForwardAgent yes
  ProxyJump router
```


# Parte 2



1. Instala el servidor apache2 en el contenedor servidorWeb.
2. Instala el servidor nfs en la máquina servidorNAS.
3. Crea en el servidorNAS un directorio /srv/web con un fichero index.html y compártelo con el contenedor servidorWeb.
4. Monta ese directorio en el directorio /var/www/html del contenedor servidorWeb.
5. Configura en el router una regla de DNAT para que podamos acceder al servidor Web desde el exterior. (La configuración debe ser persistente.)


Paso a seguir para la configuración de servidorWeb

1. Haremos la linstalacion de apache, con el siguiente comando:

```apt install -y apache2```

Donde habilitamos y arrancamos el servicio de Apache

```
systemctl enable apache2
systemctl start apache2
```
Pasos a seguir para la configuración de servidorNAS

1. Instalacion del servidor NFS en este servidor

tendremos que acturalizar el sistema, con ```apk update```

Instalar el paquete NFS con ```apk add nfs-utils``` 

2. Creamos el directorio /srv/web y el archivo el cual se llamada index.html

Crear el directorio --> ```mkdir -p /srv/web```

Crear el archifo index.html --> ```echo "<h1>Bienvenido al Servidor Web</h1>" > /srv/web/index.html```

3. Configuramos el servuidor NFS del servidorNAS.

Para ello editaremo lo siguiente:

```
nas-andy:~# cat /etc/exports 
# /etc/exports
#
# See exports(5) for a description.

# use exportfs -arv to reread
#/export    192.168.1.10(rw,no_root_squash)

/srv/web 192.168.200.33(rw,sync,no_subtree_check)
```

Exportamos el nuevo sistema de archivos: 

```exportfs -a```

Y vemos lo que sera el estado si se hizo bien:

```
nas-andy:~# exportfs -v
/srv/web      	192.168.200.33(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```
y ahora iniciamos el servicio NFS

```
nas-andy:~# rc-service nfs start
 * WARNING: nfs has already been started

```

En el servidorWeb montaremos el director NFS, de la siguiente manera:

```
# Crear el directorio de montaje
mkdir -p /var/www/html

# Montar el directorio NFS
mount -t nfs 192.168.200.56:/srv/web /var/www/html
```

Y la regla DNAT en el router para que se vea:

```
sudo iptables -t nat -A PREROUTING -i enp2s0 -p tcp --dport 80 -j DNAT --to-destination 192.168.200.20:80
```
