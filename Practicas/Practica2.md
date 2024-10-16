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


## Parte automatizar clientes.

He hecho el siguiente script:

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios$ cat crear_clientes.sh 
#!/bin/bash

# Solicitar al usuario los parámetros
read -p "Introduce el nombre de la máquina: " NOMBRE_MAQUINA
read -p "Introduce el tamaño del volumen (ejemplo: 10G): " TAMANO_VOLUMEN
read -p "Introduce el nombre de la red: " NOMBRE_RED

# Verificar que los valores no estén vacíos
if [[ -z "$NOMBRE_MAQUINA" || -z "$TAMANO_VOLUMEN" || -z "$NOMBRE_RED" ]]; then
    echo "Todos los campos son obligatorios."
    exit 1
fi

# Ruta de la plantilla y directorio de los discos
PLANTILLA="/var/lib/libvirt/images/planitilla-practica1-reducida.qcow2"
DISCO_DIR="/var/lib/libvirt/images"

# Crear el nuevo volumen
NUEVO_DISCO="${DISCO_DIR}/${NOMBRE_MAQUINA}.qcow2"
qemu-img create -f qcow2 -b "$PLANTILLA" -F qcow2 "$NUEVO_DISCO" "$TAMANO_VOLUMEN"

# Redimensionar sistema de ficheros
virt-resize --expand /dev/sda1 "$PLANTILLA" "$NUEVO_DISCO"

# Personalizar la máquina (hostname, claves SSH, red y SSH)
virt-customize -a "$NUEVO_DISCO" \
  --hostname "$NOMBRE_MAQUINA" \
  --ssh-inject debian:file:/home/madandy/.ssh/andy.pub \
  --run-command 'echo "PermitRootLogin yes" >> /etc/ssh/sshd_config' \
  --run-command 'ssh-keygen -A' \
  --run-command 'systemctl enable ssh' \
  --run-command 'systemctl start ssh' \
  --run-command 'echo -e "auto ens3\niface ens3 inet dhcp" >> /etc/network/interfaces' \
  --run-command 'ifup ens3'  # Levantar la interfaz ens3 utilizando ifup

# Crear la máquina virtual con la red y el modelo 'virtio'
virt-install --connect qemu:///system  \
  --name "$NOMBRE_MAQUINA" \
  --ram 2048 \
  --vcpus 2 \
  --disk path="$NUEVO_DISCO" \
  --network network="$NOMBRE_RED",model=virtio \
  --import \
  --osinfo detect=on,require=off \
  --noautoconsole

# Iniciar la máquina virtual automáticamente
virsh start "$NOMBRE_MAQUINA"

echo "Máquina $NOMBRE_MAQUINA creada y en ejecución."


```

# UNa vez que ya hemos hecho el cliente 3 (seria en la practica cliente2, pero ya hice como 20000)

 >[!CAUTION]
 > eNTRAR EN EL CLIENTE Y HACER UN ```sudo ifup ens3```

 Ahora si paso a seguir:


1. Descargaremos lo quew sera el cliente de servicio web
```
debian@cliente3:~$ sudo apt install lynx
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  lynx-common
Se instalarán los siguientes paquetes NUEVOS:
  lynx lynx-common
0 actualizados, 2 nuevos se instalarán, 0 para eliminar y 0 no actualizados.
Se necesita descargar 1.803 kB de archivos.
Se utilizarán 5.757 kB de espacio de disco adicional después de esta operación.
¿Desea continuar? [S/n] s
Des:1 http://deb.debian.org/debian bookworm/main amd64 lynx-common all 2.9.0dev.12-1 [1.166 kB]
Des:2 http://deb.debian.org/debian bookworm/main amd64 lynx amd64 2.9.0dev.12-1 [637 kB]
Descargados 1.803 kB en 0s (5.284 kB/s)
Seleccionando el paquete lynx-common previamente no seleccionado.
(Leyendo la base de datos ... 29322 ficheros o directorios instalados actualment
e.)
Preparando para desempaquetar .../lynx-common_2.9.0dev.12-1_all.deb ...
Desempaquetando lynx-common (2.9.0dev.12-1) ...
Seleccionando el paquete lynx previamente no seleccionado.
Preparando para desempaquetar .../lynx_2.9.0dev.12-1_amd64.deb ...
Desempaquetando lynx (2.9.0dev.12-1) ...
Configurando lynx-common (2.9.0dev.12-1) ...
Configurando lynx (2.9.0dev.12-1) ...
update-alternatives: utilizando /usr/bin/lynx para proveer /usr/bin/www-browser 
(www-browser) en modo automático
Procesando disparadores para man-db (2.11.2-2) ...
Procesando disparadores para mailcap (3.70+nmu1) ...
```


Y para que podamos verlo lo que tendremos que hacer es lo siguiente irnos al servidorNAS y servidorWeb, y hacer lo anterior:


- Servidor NAS

```
nas-andy:~$ su -
Password: 
su: incorrect password
nas-andy:~$ su -
Password: 
nas-andy:~# exportfs -a
nas-andy:~# exportfs -v
/srv/web      	192.168.200.33(sync,wdelay,hide,no_subtree_check,sec=sys,rw,root_squash,no_all_squash)
nas-andy:~# rc-service nfs start
 * Starting rpcbind ...                                                                   [ ok ]
 * Starting NFS statd ...                                                                 [ ok ]
 * Mounting nfsd filesystem in /proc ...                                                  [ ok ]
 * Exporting NFS directories ...                                                          [ ok ]
 * Starting NFS mountd ...                                                                [ ok ]
 * Starting NFS daemon ...                                                                [ ok ]
 * Starting NFS smnotify ...                                                              [ ok ]
nas-andy:~# 


```

- Servidor Web

```
root@servidorWeb:~# ls
root@servidorWeb:~# cd /var/www/html/index.html 
-bash: cd: /var/www/html/index.html: Not a directory
root@servidorWeb:~# cd /var/www/html
root@servidorWeb:/var/www/html# cd
root@servidorWeb:~# mount -t nfs 192.168.200.56:/srv/web /var/www/html
root@servidorWeb:~# 


```
¿Por qué hacemos esto? Porque esto lo tuvimos que hacer seguido y no hara falta pero se tiene que seguir los pasos anteriores, y listo. 

Si queremos editar el fichero lo unico que tendremos que hacer es esto:

```
nas-andy:~# cd /srv/web/
nas-andy:/srv/web# lks
-sh: lks: not found
nas-andy:/srv/web# ls
index.html
nas-andy:/srv/web# nano index.html 
nas-andy:/srv/web# exportfs -a
nas-andy:/srv/web# exportfs -v
/srv/web      	192.168.200.33(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
nas-andy:/srv/web# rc-service nfs start
 * WARNING: nfs has already been started
nas-andy:/srv/web# rc-service nfs status
 * status: started
nas-andy:/srv/web# 

```

```
root@servidorWeb:~# systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor prese>
     Active: active (running) since Wed 2024-10-16 10:33:05 UTC; 11min ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 88 ExecStart=/usr/sbin/apachectl start (code=exited, status=0/SUCC>
   Main PID: 104 (apache2)
      Tasks: 55 (limit: 18748)
     Memory: 20.2M
        CPU: 100ms
     CGroup: /system.slice/apache2.service
             ├─104 /usr/sbin/apache2 -k start
             ├─105 /usr/sbin/apache2 -k start
             └─106 /usr/sbin/apache2 -k start

oct 16 10:33:05 servidorWeb systemd[1]: Starting The Apache HTTP Server...
oct 16 10:33:05 servidorWeb apachectl[102]: AH00557: apache2: apr_sockaddr_info>
oct 16 10:33:05 servidorWeb apachectl[102]: AH00558: apache2: Could not reliabl>
oct 16 10:33:05 servidorWeb systemd[1]: Started The Apache HTTP Server.

root@servidorWeb:~# cd
root@servidorWeb:~# ls
root@servidorWeb:~# cd /var/www/html/index.html 
-bash: cd: /var/www/html/index.html: Not a directory
root@servidorWeb:~# cd /var/www/html
root@servidorWeb:/var/www/html# cd
root@servidorWeb:~# mount -t nfs 192.168.200.56:/srv/web /var/www/html
root@servidorWeb:~# mount -t nfs 192.168.200.56:/srv/web /var/www/html
root@servidorWeb:~# 

```

vemos que se hace a traves del cliente nos sladra esto por pantalla:

```debian@cliente3:~$ lynx http://192.168.200.33```


![cliente](/img/cliente3-lynx.png)

## Parte 3 
### Ejercicio 1:
Crearmeos la nueva red, que es una red muy aislada, la cual se llamara red-intra2 para ello haremos los siguientes pasos:

1. Crear el xml, con el nomre *red-muy-aislada.xml*
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ sudo nano red-muy-aislada.xml
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ cat red-muy-aislada.xml 
<network>
  <name>red-intra2</name>
  <bridge name='br-intra2' stp='on' delay='0'/>
  <forward mode='none'/>
</network>
```

2. Una vez creado el xml, la tendemso que definir:

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-d
net-define       net-destroy      net-dhcp-leases  net-dumpxml
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-define red-muy-aislada.xml 
La red red-intra2 se encuentra definida desde red-muy-aislada.xml


```
3. Y pondremos que se autoarranque:

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-autostart red-intra 
red-intra   red-intra2  
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-autostart red-intra2 
La red red-intra2 ha sido marcada para iniciarse automáticamente
```
4. Listarlo para ver si es cierto que esta en inicio automático:
  

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-list --all
 Nombre        Estado     Inicio automático   Persistente
-----------------------------------------------------------
 default       activo     si                  si
 red-externa   activo     si                  si
 red-intra     activo     si                  si
 red-intra2    inactivo   si                  si
 red-nat       activo     si                  si
```
### Ejercicio 2

Ahor lo que tenemos que hacer es agregarla al router de la siguiente manera:

Nos vamos a virt manager y la elegimos

Como podemos ver con el comando *ip -c a*, esta abajo nuestra interfaz que es la enp8s0:
```
user@router-andy:~$ ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:96:b5:d0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.1/24 brd 192.168.200.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe96:b5d0/64 scope link 
       valid_lft forever preferred_lft forever
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:9b:9f:6a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.148/24 brd 192.168.1.255 scope global dynamic enp2s0
       valid_lft 86347sec preferred_lft 86347sec
    inet6 2a0c:5a85:a307:8f00:5054:ff:fe9b:9f6a/64 scope global dynamic mngtmpaddr 
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe9b:9f6a/64 scope link 
       valid_lft forever preferred_lft forever
4: enp8s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 52:54:00:c3:17:09 brd ff:ff:ff:ff:ff:ff
```

Por lo que tendremos que levnatrla de la siguiente manera, la vamos a hacer persistente:


```
user@router-andy:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp2s0
auto enp2s0
iface enp2s0 inet dhcp
# This is an autoconfigured IPv6 interface
#iface enp2s0 inet6 auto

# Segunda interfaz con IP estatica

auto enp1s0
iface enp1s0 inet static
    address 192.168.200.1
    netmask 255.255.255.0

auto enp8s0
iface enp8s0 inet static
    address 172.16.0.1
    netmask 255.255.0.0
user@router-andy:~$ 

```
Despues de esto lo que hacemos es levantar con el comando *sudo ifup <inetrfazque sea>*

Comprobamos que se ha levantado de locos:

```
user@router-andy:~$ ip -c a
user@router-andy:~$ ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:96:b5:d0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.1/24 brd 192.168.200.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe96:b5d0/64 scope link 
       valid_lft forever preferred_lft forever
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:9b:9f:6a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.148/24 brd 192.168.1.255 scope global dynamic enp2s0
       valid_lft 86386sec preferred_lft 86386sec
    inet6 2a0c:5a85:a307:8f00:5054:ff:fe9b:9f6a/64 scope global dynamic mngtmpaddr 
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe9b:9f6a/64 scope link 
       valid_lft forever preferred_lft forever
4: enp8s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:c3:17:09 brd ff:ff:ff:ff:ff:ff
    inet 172.16.0.1/16 scope global enp8s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec3:1709/64 scope link 
       valid_lft forever preferred_lft forever

```
Ahor vamos con la configuracion del *contendeor DHCP* -->ServidorDHCP

El cual tendremos que apagar, con el siguiente comando:

lxc-stop servidorDHCP

e irnos al archivo de configuración : *cat /var/lib/lxc/servidorDHCP/config*

Y si teniamos esto:

```
lxc.net.0.type = veth
lxc.net.0.hwaddr = 00:16:3e:df:6c:99
lxc.net.0.link = br-intra
lxc.net.0.flags = up
```
Añadiremso lo siguuente:

```
lxc.net.1.type = veth
lxc.net.1.hwaddr = 00:16:3e:df:6c:98
lxc.net.1.link = br-intra2
lxc.net.1.flags = up


```

y asi tendremos 2 interfaes en el contenedor, el cual tendremso que poner estaticamente la ip que queramos, y se quedaria asi:

Porque tenemos que modificar el fichero /etc/network/interfaces y configurarlo:

```
root@servidorDHCP:~# cat /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.200.3
    netmask 255.255.255.0
    gateway 192.168.200.1

auto eth1
iface eth1 inet static
    address 172.16.0.2
    netmask 255.255.0.0
    gateway 172.16.0.1



```


y si lo vemos ahora estaria puesto asi:

```
root@servidorDHCP:~# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if23: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:df:6c:99 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.3/24 brd 192.168.200.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fedf:6c99/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:df:6c:98 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.16.0.2/16 brd 172.16.255.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fedf:6c98/64 scope link 
       valid_lft forever preferred_lft forever

```
y para que salga a internet tendremos que ponerle el snat en el router que sera tal que asi:


*sudo iptables -t nat -A POSTROUTING -s 172.16.0.0/24 -o enp2s0 -j MASQUERADE*
```
user@router-andy:~$ sudo iptables -t nat -A POSTROUTING -s 172.16.0.0/24 -o enp2s0 -j MASQUERADE
user@router-andy:~$ sudo netfilter-persistent save
run-parts: executing /usr/share/netfilter-persistent/plugins.d/15-ip4tables save
run-parts: executing /usr/share/netfilter-persistent/plugins.d/25-ip6tables save
user@router-andy:~$ sudo cat /etc/iptables/rules.v4
# Generated by iptables-save v1.8.9 (nf_tables) on Wed Oct 16 14:34:42 2024
*filter
:INPUT ACCEPT [3171:473627]
:FORWARD ACCEPT [554:40430]
:OUTPUT ACCEPT [2327:341858]
COMMIT
# Completed on Wed Oct 16 14:34:42 2024
# Generated by iptables-save v1.8.9 (nf_tables) on Wed Oct 16 14:34:42 2024
*nat
:PREROUTING ACCEPT [602:80941]
:INPUT ACCEPT [44:6729]
:OUTPUT ACCEPT [7:427]
:POSTROUTING ACCEPT [7:427]
-A PREROUTING -i enp2s0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.200.33:80
-A POSTROUTING -s 192.168.200.0/24 -o enp2s0 -j MASQUERADE
-A POSTROUTING -s 172.16.0.0/24 -o enp2s0 -j MASQUERADE
COMMIT
# Completed on Wed Oct 16 14:34:42 2024

```

Hemos configurado el archivo .ssh/config para poder entrar directamente por ssh desde terminal, y ahora comprobaremos la ip, efectivamente nos la de DHCP y salimos al exterior:

```
madandy@toyota-hilux:~$ ssh otro-cliente 
Linux otro-cliente 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Oct 16 15:06:21 2024
debian@otro-cliente:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=12.5 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=116 time=13.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=116 time=13.7 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=116 time=13.7 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 12.535/13.322/13.723/0.478 ms
debian@otro-cliente:~$ ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:33:a9:dc brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    inet 172.16.182.236/16 brd 172.16.255.255 scope global dynamic ens3
       valid_lft 7sec preferred_lft 7sec
    inet6 fe80::5054:ff:fe33:a9dc/64 scope link 
       valid_lft forever preferred_lft forever
debian@otro-cliente:~$ 

```