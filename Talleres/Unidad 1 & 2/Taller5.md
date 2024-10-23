1. Instala LXC.

```
andy@debian:~$ sudo apt install lxc
[sudo] contraseña para andy: 
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  arch-test binutils binutils-common binutils-x86-64-linux-gnu bridge-utils
  busybox-static cloud-image-utils debootstrap dirmngr distro-info
  dns-root-data dnsmasq-base fakechroot fakeroot genisoimage gnupg gnupg-l10n
  gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm
  ibverbs-providers libaio1 libassuan0 libbinutils libboost-iostreams1.74.0
  libboost-thread1.74.0 libctf-nobfd0 libctf0 libdistro-info-perl libdpkg-perl
  libfakechroot libfakeroot libfile-fcntllock-perl l

```

2. Crea un contenedor LXC con la última distribución de Ubuntu. Lista los contenedores. Inicia el contenedor y comprueba la dirección IP que ha tomado. ¿Tiene conectividad al exterior?. Sal del contenedor y ejecuta un apt update en el contenedor sin estar conectado a él.

**Entrega: La salida del comando para listar el contenedor creado. Un pantallazo donde se vea la IP que ha tomado. La instrucción que permite ejecutar el comando apt update sin estar conectado a él.**

- Creación del contenedor:

```
andy@debian:~$ sudo lxc-create -n contenedor1 -t debian -- -r bullseye
debootstrap is /usr/sbin/debootstrap
Checking cache download in /var/cache/lxc/debian/rootfs-bullseye-amd64 ... 
Downloading debian minimal ...
I: Target architecture can be executed
I: Retrieving InRelease 
I: Checking Release signature
I: Valid Release signature (key id A4285295FC7B1A81600062A9605C66F00D6C9793)
I: Retrieving Packages 
```

- Comprobación del contenedor:

```
andy@debian:~$ sudo lxc-ls 
contenedor1 

```
- Inicio del contenedor, y comprobación de la ip que nos da:


```

andy@debian:~$ sudo lxc-start contenedor1

```

```
andy@debian:~$ sudo lxc-info -n contenedor1
Name:           contenedor1
State:          RUNNING
PID:            23368
IP:             10.0.3.181
Link:           vethchxdjX
 TX bytes:      1.70 KiB
 RX bytes:      2.79 KiB
 Total bytes:   4.48 KiB


```

- Conexión al contenedor, para ello lo tenemos que iniciar, una vez iniciado este nos podemos meter dentro de él.

```
andy@debian:~$ sudo lxc-attach contenedor1
root@contenedor1:/# 

```

- Comprobación de la salida al exterior:

```
root@contenedor1:/# ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=17.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=17.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=18.0 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 17.182/17.461/17.987/0.371 ms
root@contenedor1:/# 

```

- Actualizar paquetes desde el exterior del contenedor:

```
andy@debian:~$ sudo lxc-attach -n contenedor1 -- apt update
Obj:1 http://security.debian.org/debian-security bullseye-security InRelease
Obj:2 http://deb.debian.org/debian bullseye InRelease
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se pueden actualizar 5 paquetes. Ejecute «apt list --upgradable» para verlos.
andy@debian:~$ 

```


3. Modifica la configuración del contenedor, y limita el uso de memoria a 512M y que use una sola CPU.
**Entrega: Pantallazos para demostrar que has limitado el uso de memoria y CPU en el contenedor.**

- Modificar el fichero :
```andy@debian:~$ sudo nano /var/lib/lxc/contenedor1/config```

- Agregarle las siguientes lineas:

```

lxc.cgroup2.memory.max = 512M
lxc.cgroup2.cpuset.cpus = 0

```
- Parar y arrancar el contenedor:
  
```andy@debian:~$ sudo lxc-stop contenedor1```
```andy@debian:~$ sudo lxc-start contenedor1```

- Comprobación de memoria modificada:
``` 
andy@debian:~$ sudo lxc-attach contenedor1 -- free -h
               total        used        free      shared  buff/cache   available
Mem:           512Mi        12Mi       499Mi       0,0Ki       0,0Ki       499Mi
Swap:             0B          0B          0B

```
- Comprobacion de la **CPU**

```
andy@debian:~$ sudo lxc-attach contenedor1 -- cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
```

4. Comprueba que se ha creado un bridge llamado lxcbr0 donde está conectado el contenedor. Cambia la configuración del contenedor para desconectar de este bridge y conectarlo a la red red-nat que creaste en el taller anterior. Toma de nuevo direccionamiento y comprueba de nuevo la dirección IP, y que sigue teniendo conectividad al exterior.

**Entrega: Después de conectar el contenedor a la red red-nat, comprobación de la IP que ha tomado y de que tiene conectividad al exterior.**

- Comprobación de IP:

```
sudo lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4       IPV6 UNPRIVILEGED 
contenedor1 RUNNING 0         -      10.0.3.181 -    false    
```
- Comprobación de conectividad: 

```
andy@debian:~$ sudo lxc-attach -n contenedor1
root@contenedor1:/# ping -c 5 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=17.1 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=16.5 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=17.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=17.2 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=110 time=17.5 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 16.464/17.124/17.531/0.363 ms
root@contenedor1:/# 

```

5. Añade una nueva interfaz de red al contenedor y conéctala a la red red-externa que creaste en el taller anterior. Toma direccionamiento en esta nueva interfaz y comprueba que esta en el direccionamiento del instituto.

**Entrega: Después de conectar el contenedor a la red red-externa, comprobación de la nueva IP que ha tomado.**

```
sudo lxc-ls -f
NAME        STATE   AUTOSTART GROUPS IPV4       IPV6 UNPRIVILEGED 

contenedor1 RUNNING 0         -      10.0.3.181 -    false    

contenedor1 RUNNING 0         -      172.22.8.204 -    false
```
6. Crea en el host el directorio /opt/web, crea el fichero index.html y monta este directorio en el directorio /srv/www del contenedor.

**Entrega: Indica la configuración que has hecho para montar el directorio /opt/web. Lista el directorio /srv/www del contenedor para comprobar que se ha montado de forma correcta.**

lxc.mount.entry = /opt/web srv/www none bind,create=dir 0 0

andy@contenedor1:/# cd /srv/www/

andy@contenedor1:/srv/www# ls
index.html


