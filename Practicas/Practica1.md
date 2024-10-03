# Práctica 1

## Ejercicio 1

### Creación de la maquina:

```
alejandro$ virt-install --connect qemu:///system \
--virt-type kvm \
--name practica1 \
--cdrom ~/iso/debian-12.7.0-amd64-netinst.iso \
--os-variant debian11 \
--disk size=3 \
--memory 1024 \
--vcpus 1
Empezando la instalación...

```
>[!WARNING]
> Instalación de máquina virtual

_Mientras que estan la instalación, si no ponemos contraseña en el root, directamente el usuario que creemos se metera en el grupo sudoers._

### Entramos como root, y hacemos un update, y la instalación.

```
root@debian:~# apt update
root@debian:~# apt install sudo
root@debian:~# usermod -aG sudo debian
root@debian:~# visudo

```

### Entramos en el archivo y editamos la siguiente linea, y la cambiamos por esta:

```
sudo ALL=(ALL:ALL) ALL > sudo ALL=(ALL:ALL) NOPASSWD: ALL

```
### Para copiar la clave publica de mi máquina fisica y la del profesor, en el usuario debin de la máquina virtual, crearenos el directorio .ssh y el fichero autohorized_keys, en el que pegaremos ambas claves.

```
debian@debian:~$ mkdir -p ~/.ssh
debian@debian:~$ chmod 700 ~/.ssh
debian@debian:~$ nano ~/.ssh/authorized_keys
```
### Lo pasamos a lo que sera al archivo:
>[!CAUTION] 
> Esto es la vm virtual
```
touch /home/debian/.ssh/authorized_keys
```

>[!WARNING]
> Esto es mi máquina

```
scp .ssh/andy.pub debian@192.168.122.152:/home/debian/.ssh
scp .ssh/jose.pub debian@192.168.122.152:/home/debian/.ssh
scp .ssh/rafa.pub debian@192.168.122.152:/home/debian/.ssh

```
>[!CAUTION] 
> Esto es la vm virtual


```
cat /home/debian/.ssh/andy.pub >> /home/debian/.ssh/authorized_keys
cat /home/debian/.ssh/jose.pub >> /home/debian/.ssh/authorized_keys
cat /home/debian/.ssh/rafa.pub >> /home/debian/.ssh/authorized_keys
```
### Comprobación de la conexión, sin contraseña:


```
madandy@toyota-hilux:~$ ssh debian@192.168.122.40
Linux debian 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Oct  2 09:02:20 2024
debian@debian:~$ 

```
### Creación de la plantilla

```
madandy@toyota-hilux:~$ sudo virt-sysprep -d practica1 --hostname plantilla-cliente
[sudo] contraseña para madandy: 
[   0.0] Examining the guest ...
[   5.5] Performing "abrt-data" ...
[   5.5] Performing "backup-files" ...
[   5.7] Performing "bash-history" ...
[   5.7] Performing "blkid-tab" ...
[   5.7] Performing "crash-data" ...
[   5.7] Performing "cron-spool" ...
[   5.8] Performing "dhcp-client-state" ...
[   5.8] Performing "dhcp-server-state" ...
[   5.8] Performing "dovecot-.....

```

### Por ultimo le quitamos los permisos al archivo *qcow2* para que solo sea un archivo de solo lectura, y le cambiamos el nomnre a la máquina que ahora hemos convertido en plantilla.

```
madandy@toyota-hilux:~$ cd /var/lib/libvirt/images/

madandy@toyota-hilux:/var/lib/libvirt/images$ sudo ls
practica1.qcow2

madandy@toyota-hilux:/var/lib/libvirt/images$ sudo chmod -w practica1.qcow2

madandy@toyota-hilux:/var/lib/libvirt/images$ virsh -c qemu:///system domrename practica1 plantilla-clienteDomain successfully renamed
```

## Ejercicio 2


### Comprobación de que estan los permisos quitados:

```
madandy@toyota-hilux:~$ virsh -c qemu:///system start plantilla-cliente 
error: Failed to start domain 'plantilla-cliente'
error: error interno: process exited while connecting to monitor: 2024-10-02T08:10:24.396343Z qemu-system-x86_64: -blockdev {"node-name":"libvirt-2-format","read-only":false,"discard":"unmap","driver":"qcow2","file":"libvirt-2-storage","backing":null}: Could not open '/var/lib/libvirt/images/practica1.qcow2': Permission denied
```

### Comprobacion de lo que ocupa:

```
madandy@toyota-hilux:~$ cd /var/lib/libvirt/images


madandy@toyota-hilux:/var/lib/libvirt/images$ sudo ls
practica1.qcow2


madandy@toyota-hilux:/var/lib/libvirt/images$ du -h practica1.qcow2
2,0G	practica1.qcow2

```

### Reducción del volumen y comprobación:

```
madandy@toyota-hilux:~$ sudo virt-sparsify /var/lib/libvirt/images/practica1.qcow2 /var/lib/libvirt/images/practica1-reducida.qcow2
[   0.0] Create overlay file in /tmp to protect source disk
[   0.0] Examine source disk
[   3.2] Fill free space in /dev/sda1 with zero
[   4.2] Clearing Linux swap on /dev/sda5
[   5.1] Copy to destination and make sparse
[   8.1] Sparsify operation completed with no errors.
virt-sparsify: Before deleting the old disk, carefully check that the 
target disk boots and works correctly.

madandy@toyota-hilux:~$ cd /var/lib/libvirt/images

madandy@toyota-hilux:/var/lib/libvirt/images$ du -h practica1.qcow2
2,0G	practica1.qcow2

madandy@toyota-hilux:/var/lib/libvirt/images$ du -h practica1-reducida.qcow2
1,4G	practica1-reducida.qcow2

```

# CLONACION ENLAZADA DE UNA PLANTILLA

- La imagen de la MV clonada utiliza la imagen de la plantilla como imagen base
(backing store) en modo de sóolo lectura.
- La imagen de la nueva MV sólo guarda los cambios del sistema de archivo.
Requiere menos espacio en disco, pero no puede ejecutarse sin acceso a la
imagen de plantilla base.
* Mecanismo:
1. Creación del nuevo volumen a a partir de la imagen base de la plantilla (backing
store).
2. Creación de la nueva máquina usando virt-install, virt-manager o virt-clone

* Para no complicar la creación de volúmenes con backing store vamos a indicar
el tamaño del nuevo volumen igual al de la imagen base.
* Si es distinto (más grande) tendríamos que redimensionar el sistema de
archivos.

## *Pasos:*

- Comprobar el tamaño de la imagen de la plantilla:

```virsh -c qemu:///system domblkinfo plantilla-cliente vda --human```

### Creación de los clientes

#### Cliente 1

- Creamos la nueva imagen usando _virsh_ :

```
virsh -c qemu:///system vol-create-as default vol_clon_plantilla_cliente1.qcow2 3G \
                                    --format qcow2 \
                                    --backing-vol practica1.qcow2 \
                                    --backing-vol-format qcow2

Se ha creado el volumen vol_clon_plantilla_cliente1.qcow2
```
- Obtenemos informacion de la nueva imagen usando _virsh_:

```virsh -c qemu:///system vol-dumpxml vol_clon_plantilla_cliente1.qcow2 default```

- Creación de la nueva *MÁQUINA VIRTUAL*

```
virt-clone --connect=qemu:///system \
                --original plantilla-cliente \
                --name cliente1 \
                --file /var/lib/libvirt/images/vol_clon_plantilla_cliente1.qcow2 \
                --preserve-data
```

### Cliente 2

- Creamos la nueva imagen usando _virsh_ :

```
virsh -c qemu:///system vol-create-as default vol_clon_plantilla_cliente2.qcow2 3G \
                                    --format qcow2 \
                                    --backing-vol practica1.qcow2 \
                                    --backing-vol-format qcow2

Se ha creado el volumen vol_clon_plantilla_cliente2.qcow2
```
- Obtenemos informacion de la nueva imagen usando _virsh_:

```virsh -c qemu:///system vol-dumpxml vol_clon_plantilla_cliente2.qcow2 default```

- Creación de la nueva *MÁQUINA VIRTUAL*

```
virt-clone --connect=qemu:///system \
                --original plantilla-cliente \
                --name cliente2 \
                --file /var/lib/libvirt/images/vol_clon_plantilla_cliente2.qcow2 \
                --preserve-data
```


# Parte2

## Práctica 2/3: Virtualización en Linux y servidor DHCP (Parte 1)

### Creación del escenario

![Escenario](img/escenario.png)


# Crea una red muy aislada, que se llame red_intra que creará el puente br-intra. Esta red se tiene que iniciar cada vez que encendemos el host.
Tendremos que tener un fichero en xml, que pondra lo siguiente: 

```
<network>
  <name>red_intra</name>  
  <bridge name='br-intra' stp='on' delay='0'/>
  <forward mode='none'/>
</network>
```
Una vez creado el fichero, tendremos que irnos a donde esta y abrir la terminal (*por comodidad*), y hacer lo siguiente:

- Definir la red:
  
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$  virsh -c qemu:///system net-define red-intra.xml
La red red-intra se encuentra definida desde red-intra.xml
```
- Iniciar la red:
  
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-start red-intra 
La red red-intra se ha iniciado
```
- Iniciar automaticamente la red cada vez que arranquemos:
  
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-autostart red-intra 
La red red-intra ha sido marcada para iniciarse automáticamente
```
- Comprobar con el siguiente comando, la lista de las redes que tenemos activadas, y con su correspondiente inicio automático:
  
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-list
 Nombre        Estado   Inicio automático   Persistente
---------------------------------------------------------
 default       activo   si                  si
 red-externa   activo   si                  si
 red-intra     activo   si                  si
 red-nat       activo   si                  si
```

### Creación del router

>[!CAUTION] 
> Al estar la iso directamente en el home, tendremos que poner la *~*


```
madandy@toyota-hilux:~$ virt-install --connect qemu:///system \
  --virt-type kvm \
  --name router-andy \
  --cdrom ~/iso/debian-12.7.0-amd64-netinst.iso \
  --os-variant debian11 \
  --network network=red-intra \
  --network bridge=br0 \
  --disk path=/var/lib/libvirt/images/disco_raw.img,format=raw,size=10 \
  --memory 1024 \
  --vcpus 1


```

- Para esta ocasión al hacerlo, he descargado el ```apt sudo``` y meter al usuario _user_ dentro del grupo sudoers, como anteriormente.

- Una vez hecho esto he tenido que hacer un fichero el en *.ssh/authorized_keys* y copiarlo de mi *host* a la máquina virtual.

- Si hacemos lo que seria la conexión seria tal que asi:

```
user@router-andy:~$ mkdir -p ~/.ssh
user@router-andy:~$ chmod 700 ~/.ssh
user@router-andy:~$ nano ~/.ssh/authorized_keys
user@router-andy:~$ 
cerrar sesión
Connection to 172.22.7.27 closed.
madandy@toyota-hilux:~$ ssh user@172.22.7.27
Linux router-andy 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Oct  3 10:19:01 2024 from 172.22.7.202

```
- Configuramos la red estatica, de la siguiente manera:

1. Vemos las interfaces con ```ip a```, vemos la que no esta levantada, que en este caso sera _enp1s0_

2. Para poner la interfaz estatica, editaremos el siguiente archivo:

```sudo nano /etc/network/interfaces```

3. Una vez que lo hemos editado tendremos que levantar la interfaz, pero como esta no estaba levantada, si no que estaba *down* pues metemos el siguiente comando:

 ```user@router-andy:~$ sudo systemctl restart networking```

4. Comprobamos la ip, con el comando *ip a*

```
user@router-andy:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:8e:63:25 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.1/24 brd 192.168.200.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe8e:6325/64 scope link 
       valid_lft forever preferred_lft forever
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:21:45:2c brd ff:ff:ff:ff:ff:ff
    inet 172.22.7.27/16 brd 172.22.255.255 scope global dynamic enp2s0
       valid_lft 86100sec preferred_lft 86100sec
    inet6 fe80::5054:ff:fe21:452c/64 scope link 
       valid_lft forever preferred_lft forever


```
5. Poner en auto arranque:

```
madandy@toyota-hilux:~$ sudo virsh -c qemu:///system autostart router-andy 
Domain 'router-andy' marked as autostarted
```

### Creación del servidorNAS

```
qemu-img create -f qcow2 /var/lib/libvirt/images/servidorNAS.qcow2 15G
```

```
virt-install --connect qemu:///system 
                        --virt-type kvm \
                        --name servidorNAS \ 
                        --cdrom ~/iso/alpine-standard-3.20.3-x86_64.iso \
                        --os-variant alpinelinux3.17 \
                        --network network=default \
                        --disk vol=default/servidorNAS.qcow2 \ 
                        --memory 1024 \
                        --vcpus 1 
```

Despues de hacer la configuración pertinente, hemos metido la nueva interfaz para la *red-intra*

```
nas-andy:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:c7:be:72 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.113/24 brd 192.168.122.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec7:be72/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 52:54:00:f0:ba:36 brd ff:ff:ff:ff:ff:ff
```
Levnatamos la eth1, pero pimero hacemos la configuracon:
```
auto eth1
iface eth1 inet static
    address 192.168.200.2
    netmask 255.255.255.0
```
y quedaria asi:

```
/home/user # nano /etc/network/interfaces 
/home/user # ifup eth1
/home/user # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:c7:be:72 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.113/24 brd 192.168.122.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec7:be72/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 52:54:00:f0:ba:36 brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.2/24 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fef0:ba36/64 scope link 
       valid_lft forever preferred_lft forever
```
Una vez que haga esto quitamos la red default, y no nos podremos meter por ssh, si no que tendremos que meter a traves de su consola, si hacemos un ip a no nos sladrta ninguna ip, por lo que tendremso que merternos en lo de las iinetrfaces y cambiar el eth1 por eth0, y si nos saldra la estatuica que pusimos.

### Creación de contenedores

#### Contendero servidorDHCP

iNSTALE LAS PLANTILLAS NECESARIAS:

```
apt install lxc debootstrap
```


```
madandy@toyota-hilux:~$ sudo lxc-create -n servidorDHCP -t debian -- --release bookworm
debootstrap is /usr/sbin/debootstrap
Checking cache download in /var/cache/lxc/debian/rootfs-bookworm-amd64 ... 
Downloading debian minimal ...
I: Target architecture can be executed
I: Retrieving InRelease 
I: Checking Release signature
I: Valid Release signature (key id 4D64FEC119C2029067D6E791F8D2585B8783D481)
I: Retrieving Packages 
```

#### Contenedor servidorWEB

```
madandy@toyota-hilux:~$ sudo lxc-create -n servidorWeb -t ubuntu -- --release jammy
Checking cache download in /var/cache/lxc/jammy/rootfs-amd64 ... 
Installing packages in template: apt-transport-https,ssh,vim,language-pack-en
Downloading ubuntu jammy minimal ...
I: Target architecture can be executed
W: Cannot check Release signature; keyring file not available /usr/share/keyrings/ubuntu-archive-keyring.gpg
I: Retrieving InRelease 

```

Ahora lo que haremos sera entrar con el comando:

```
sudo lxc-attach -n servidorDHCP
```

y editaremos el fichero para que nos deje entrar desde nuestro host al servidorDHCP

```
root@servidorDHCP:~# nano /etc/ssh/sshd_config
root@servidorDHCP:~# systemctl restart ssh
root@servidorDHCP:~# cd .ssh/
root@servidorDHCP:~/.ssh# ls
root@servidorDHCP:~/.ssh# nano authorized_keys
root@servidorDHCP:~/.ssh# ls
authorized_keys
root@servidorDHCP:~/.ssh# reboot
Failed to connect to bus: No existe el fichero o el directorio
root@servidorDHCP:~/.ssh# 
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorDHCP
root@servidorDHCP:/# 
```

#### ServidorWeb

```
root@servidorWeb:~# mkdir .ssh
root@servidorWeb:~# cd .ssh/
root@servidorWeb:~/.ssh# nano authorized_keys
root@servidorWeb:~/.ssh# cd
root@servidorWeb:~# chmod 700 .ssh/
root@servidorWeb:~# cd .ssh/
root@servidorWeb:~/.ssh# chmod 600 authorized_keys 
root@servidorWeb:~/.ssh# restart
bash: restart: command not found
root@servidorWeb:~/.ssh# cd
root@servidorWeb:~# reboot 
root@servidorWeb:~# 
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorWeb
root@servidorWeb:/# 
```

Y entrando desde el host 

```
madandy@toyota-hilux:~/.ssh$ ssh root@10.0.3.87
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.1.0-25-amd64 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@servidorWeb:~# 
```
#### Ponerlo automaticamente y su ip 

Servidor web

```
root@servidorWeb:/# nano /etc/netplan/10-lxc.yaml 
root@servidorWeb:/# reboot 
root@servidorWeb:/# 
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorWeb
root@servidorWeb:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:9a:f5:61 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.4/24 brd 192.168.200.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fe9a:f561/64 scope link 
       valid_lft forever preferred_lft forever
root@servidorWeb:/# 
```

#### Servidor DHCP

```
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorDHCP
root@servidorDHCP:/# nano /etc/network/interfaces
root@servidorDHCP:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if29: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:df:6c:99 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::216:3eff:fedf:6c99/64 scope link 
       valid_lft forever preferred_lft forever
root@servidorDHCP:/# nano /etc/network/interfaces
root@servidorDHCP:/# reboot 
Failed to connect to bus: No existe el fichero o el directorio
root@servidorDHCP:/# 
madandy@toyota-hilux:~$ sudo lxc-attach -n servidorDHCP
root@servidorDHCP:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:df:6c:99 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.200.3/24 brd 192.168.200.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fedf:6c99/64 scope link 
       valid_lft forever preferred_lft forever
root@servidorDHCP:/# 

```

