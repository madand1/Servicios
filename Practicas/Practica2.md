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

![cliente_dhcp](img/dhcp-client1.png)

Para ello lo que hemos hecho ha sido lo siguiente:

- Meternos en el fichero de configuración de las redes:

```sudo nano /etc/network/interfaces```

- Configurar la interfaz de red:

```
auto enp7s0
iface enp7s0 inet dhcp
```

Y vemos como se da con la imagen de arriba