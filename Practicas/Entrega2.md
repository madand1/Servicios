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