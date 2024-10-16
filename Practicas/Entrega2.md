h2. Contenido de los ficheros de configuración que has modificado en el servidor DHCP.

<pre>
Esto sera en el archivo de configuracion nano /etc/default/isc-dhcp-server y buscamos la linea que pone INTERFACESv4="" y cambiamos el valor POR TU TARJETA DE RED, en mi caso es eth0, con lo que quedaria asi:

INTERFACESv4="eth0"

</pre>

En el fichero nano /etc/dhcp/dhcpd.conf y le agregamos esta confirguacion:

<pre>

# Configuración del DHCP
default-lease-time 1800;  # 30 minutos
max-lease-time 1800;      # 30 minutos

subnet 192.168.200.0 netmask 255.255.255.0 {
    range 192.168.200.10 192.168.200.200;   # Rango de direcciones IP
    option routers 192.168.200.1;           # Puerta de enlace predeterminada
    option subnet-mask 255.255.255.0;       # Máscara de red
    option domain-name-servers 172.22.0.1;  # Servidor DNS
}
</pre>

h2. Una comprobación donde se vea la ip que ha tomado de forma dinámica el cliente1 y el cliente windows.

<pre>


</pre>

h2. Una comprobación donde se comprueba que los dos clientes tienen conectividad al exterior.

Cliente1

<pre>

debian@Cliente1-andy:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=116 time=12.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=116 time=13.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=116 time=14.3 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=116 time=13.7 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 12.257/13.338/14.258/0.734 ms
debian@Cliente1-andy:~$ 


</pre>

Cliente Windows

<pre>


</pre>

h2. El contenido del fichero de concesiones en el servidor dhcp para comprobar que se han concedido esas direcciones IP.

En el fichero:

<pre>
cat /var/lib/dhcp/dhc
</pre>


<pre>

root@servidorDHCP:/# cat /var/lib/dhcp/dhc
dhclient.eth0.leases  dhcpd.leases          dhcpd.leases~
root@servidorDHCP:/# cat /var/lib/dhcp/dhc
dhclient.eth0.leases  dhcpd.leases          dhcpd.leases~
root@servidorDHCP:/# cat /var/lib/dhcp/dhcpd.leases
# The format of this file is documented in the dhcpd.leases(5) manual page.
# This lease file was written by isc-dhcp-4.4.3-P1

# authoring-byte-order entry is generated, DO NOT DELETE
authoring-byte-order little-endian;

lease 192.168.200.21 {
  starts 4 2024/10/10 07:39:17;
  ends 4 2024/10/10 07:39:27;
  tstp 4 2024/10/10 07:39:27;
  cltt 4 2024/10/10 07:39:17;
  binding state free;
  hardware ethernet 52:54:00:b5:2d:1d;
  uid "\001RT\000\265-\035";
  set vendor-class-identifier = "MSFT 5.0";
}
lease 192.168.200.20 {
  starts 4 2024/10/10 07:39:26;
  ends 4 2024/10/10 07:39:30;
  tstp 4 2024/10/10 07:39:30;
  cltt 4 2024/10/10 07:39:26;
  binding state free;
  hardware ethernet 52:54:00:56:fa:0b;
  uid "\377\000V\372\013\000\001\000\001.\230\363oRT\000V\372\013";
}

.....
....
...
lease 192.168.200.20 {
  starts 4 2024/10/10 14:17:48;
  ends 4 2024/10/10 14:17:58;
  cltt 4 2024/10/10 14:17:48;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 52:54:00:56:fa:0b;
  uid "\377\000V\372\013\000\001\000\001.\230\363oRT\000V\372\013";
  client-hostname "Cliente1-andy";
}
lease 192.168.200.21 {
  starts 4 2024/10/10 14:17:51;
  ends 4 2024/10/10 14:18:01;
  cltt 4 2024/10/10 14:17:51;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 52:54:00:b5:2d:1d;
  uid "\001RT\000\265-\035";
  set vendor-class-identifier = "MSFT 5.0";
  client-hostname "DESKTOP-MJJSLS3";
}
....
......
........
</pre>

h2. Comprobación donde se vean los 4 paquetes que se transmite en la negociación de la concesión.

<pre>

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


</pre>

h2. Explica, con pruebas de funcionamiento, el motivo del comportamiento que se indica en los puntos 5 y 6. Muestra al profesor el funcionamiento del punto 5 y 6.


<pre>



</pre>

h2. Muestra la configuración para hacer las reservas.

<pre>
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

</pre>

h2. Una captura de pantalla donde se vea la ip que ha tomado de forma dinámica el servidorWeb y el servidorNAS. ¿Las reservas se guardan en el fichero de concesión del servidor dhcp?

Las reservas son configuraciones predefinidas, en este caso por mi, y esto lo que hace es que las meta a mano en el fichero /etc/dhcp/dhcp.conf, mierras que las conlas concesiones son direcciones IP que el server de DHCP ha asigando de manera temporal y estas se almacenan en el archivo de concesiones, o lo que es lo mismo en este fichero /var/lib/dhcp/dhcpd.leases.

En conclusion no se guardan en el mismo fichero.

h1. Parte2

h2. Configuración y demostración que has exportado un directorio desde el servidorNAS.

<pre>



nas-andy:~# mkdir -p /srv/web
nas-andy:~# echo "<html><body><h1>Bienvenido al servidor web</h1></body></html>" > /srv/web/index.html
nas-andy:~# nano /etc/exports
nas-andy:~# cat /etc/exports 
# /etc/exports
#
# See exports(5) for a description.

# use exportfs -arv to reread
#/export    192.168.1.10(rw,no_root_squash)

/srv/web 192.168.200.33(rw,sync,no_subtree_check)
nas-andy:~# exportfs -arv
exporting 192.168.200.33:/srv/web
nas-andy:~# exportfs -v
/srv/web      	192.168.200.33(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)

</pre>

h2. Demostración donde se vea que has montado el directorio indicado en el contenedor.

<pre>
root@servidorWeb:~# mount | grep nfs
192.168.200.56:/srv/web on /var/www/html type nfs4 (rw,relatime,vers=4.2,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.200.33,local_lock=none,addr=192.168.200.56)
root@servidorWeb:~# 

</pre>

h2. Demostración donde se vea el acceso al servidor web desde el exterior.



h2. Cambia el contenido del fichero index.html en el servidorNAS y accede a la página para comprobar que se han producido los cambios,

<pre>
nas-andy:~# echo "<html><body><h1>For the emperor</h1></body></html>" > /srv/web/index.html
nas-andy:~# 
</pre>


h1. Script de creación de clientes

h2.. Entrega el script que has diseñado.

<pre>

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

</pre>

h2. Una comprobación de que el tamaño del disco (y de su sistema de fichero) de la máquina creada es el adecuado.

<pre>
debian@cliente3:~$ df -h
S.ficheros     Tamaño Usados  Disp Uso% Montado en
udev             962M      0  962M   0% /dev
tmpfs            197M   520K  197M   1% /run
/dev/sda1        8,9G   1,3G  7,2G  15% /
tmpfs            984M      0  984M   0% /dev/shm
tmpfs            5,0M      0  5,0M   0% /run/lock
tmpfs            197M      0  197M   0% /run/user/1000
debian@cliente3:~$ 

</pre>
h2. Una vez creado el cliente2, pruebas de funcionamiento del direccionamiento que ha tomado y de que tiene acceso al exterior.

<pre>
debian@cliente3:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=18.4 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=18.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=17.9 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 17.945/18.167/18.394/0.183 ms
debian@cliente3:~$ 

</pre>

h2. Un acceso por ssh a cliente2 donde se demuestre que no se pide contraseña.

<pre>

madandy@toyota-hilux:~$ ssh cliente3
Linux cliente3 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Oct 16 09:34:52 2024 from 192.168.200.1
debian@cliente3:~$ 

</pre>


h2. Instala un cliente web de texto en cliente2 y accede a la página web de servidorWeb.

<pre>
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
<pre>

Nos conectamso al servidor Web

</pre>
debian@cliente3:~$ lynx http://192.168.200.33


Exiting via interrupt: 2

</pre>

![cliente](/img/cliente3-lynx.png)