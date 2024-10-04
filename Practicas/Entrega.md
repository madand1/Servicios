h1. Practica 1:Virtualización en Linux y servidor DHCP (Parte 2)

h2. Fichero xml con la definición de la red red_intra, la instrucción de creación y la que permite el inicio automático.

Fichero XML, de red_intra:

<pre>

<network>
  <name>red_intra</name>  
  <bridge name='br-intra' stp='on' delay='0'/>
  <forward mode='none'/>
</network>

</pre>

Iniciar la red:

<pre>

madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$  virsh -c qemu:///system net-define red-intra.xml
La red red-intra se encuentra definida desde red-intra.xml

</pre>

niciar automaticamente la red cada vez que arranquemos

<pre>

madandy@toyota-hilux:~/Documentos/SegundoASIR/redes$ virsh -c qemu:///system net-autostart red-intra 
La red red-intra ha sido marcada para iniciarse automáticamente

Con el siguiente comando, podemos ver la comprovbación buscando lo que seria la *<disk>*

</pre>




h2. Comprobación que el volumen de la máquina router tiene el formato raw.
<pre>
madandy@toyota-hilux:~$ virsh -c qemu:///system dumpxml router-andy
....
....
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw' discard='unmap'/>
      <source file='/var/lib/libvirt/images/disco_raw.img' index='2'/>
      <backingStore/>
....
....

Para esta pregunta, hare la siguienets comandos:





h2. El comando virsh que muestra información de las máquinas router y servidorNAS para comprobar que se inicia de forma automática.

<pre>


madandy@toyota-hilux:~$ virsh -c qemu:///system dominfo servidorNAS 
Id:             1
Nombre:         servidorNAS
UUID:           8a0d28a6-28bc-4bee-96b6-7558f9490aa7
Tipo de sistema operatuvo: hvm
Estado:         ejecutando
CPU(s):         1
Hora de la CPU: 17,3s
Memoria máxima: 1048576 KiB
Memoria utilizada: 1048576 KiB
Persistente:    si
Autoinicio:     activar
Guardar administrado: no
Modelo de seguridad: apparmor
DOI de seguridad: 0
Etiqueta de seguridad: libvirt-8a0d28a6-28bc-4bee-96b6-7558f9490aa7 (enforcing)

madandy@toyota-hilux:~$ virsh -c qemu:///system dominfo router-andy 
Id:             2
Nombre:         router-andy
UUID:           068f825b-4962-4cc1-b53a-033b6ace9099
Tipo de sistema operatuvo: hvm
Estado:         ejecutando
CPU(s):         1
Hora de la CPU: 49,3s
Memoria máxima: 1048576 KiB
Memoria utilizada: 1048576 KiB
Persistente:    si
Autoinicio:     activar
Guardar administrado: no
Modelo de seguridad: apparmor
DOI de seguridad: 0
Etiqueta de seguridad: libvirt-068f825b-4962-4cc1-b53a-033b6ace9099 (enforcing)

</pre>

h2. Salida del comando ip a en router.

<pre>

user@router-andy:~$ ip a
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
    inet 172.22.6.245/16 brd 172.22.255.255 scope global dynamic enp2s0
       valid_lft 75881sec preferred_lft 75881sec
    inet6 fe80::5054:ff:fe9b:9f6a/64 scope link 
       valid_lft forever preferred_lft forever
user@router-andy:~$ 

</pre>

h2. Acceso por ssh sin que te pida la contraseña al router.

<pre>

madandy@toyota-hilux:~$ ssh router 
Linux router-andy 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Oct  4 12:08:28 2024 from 172.22.7.202
user@router-andy:~$ 


</pre>

h2. Acceso por ssh sin que te pida la contraseña al servidorNAS.

<pre>

madandy@toyota-hilux:~$ ssh servidorNAS 
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

nas-andy:~$ 

</pre>

h2. Lista los contenedores creados para que se visualice su dirección IP y se vea que se inician de forma automática.

<pre>

madandy@toyota-hilux:~$ sudo lxc-ls -f
[sudo] contraseña para madandy: 
NAME         STATE   AUTOSTART GROUPS IPV4          IPV6 UNPRIVILEGED 
servidorDHCP RUNNING 1         -      192.168.200.3 -    false        
servidorWeb  RUNNING 1         -      192.168.200.4 -    false  

</pre>

h2. Prueba de funcionamiento de que se ha limitado la memoria de los contenedores de forma adecuada.

- Antes de limitarla:

<pre>

adandy@toyota-hilux:~$ sudo su
root@toyota-hilux:/home/madandy# lxc-attach servidorDHCP -- free -h
               total       usado       libre  compartido   búf/caché   disponible
Mem:            15Gi        10Mi        15Gi        40Ki        30Mi        15Gi
Inter:            0B          0B          0B
root@toyota-hilux:/home/madandy# lxc-attach servidorWeb -- free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi        30Mi        15Gi       0,0Ki        49Mi        15Gi
Swap:             0B          0B          0B
root@toyota-hilux:/home/madandy# 

</pre>

- Despues de limitarla:

<pre>


</pre>

h2. Salida de la instrucción iptables que muestra la regla de SNAT que has configurado.

- Regla:

<pre>
-A POSTROUTING -s 192.168.200.0/24 -o enp2s0 -j MASQUERADE
</pre>

- Comprobación:

<pre>

Chain POSTROUTING (policy ACCEPT 15 packets, 1066 bytes)
 pkts bytes target     prot opt in     out     source               destination         
   53  3655 MASQUERADE  0    --  *      enp2s0  192.168.200.0/24     0.0.0.0/0  
</pre>

h2. Comprobación que los contenedores tienen acceso al exterior.

<pre>
root@toyota-hilux:~# lxc-attach servidorDHCP
root@servidorDHCP:~# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=16.7 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=17.1 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 16.735/16.897/17.060/0.162 ms
root@servidorDHCP:~# exit
exit
root@toyota-hilux:~# lxc-attach servidorWeb 
root@servidorWeb:~# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=17.4 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=17.1 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 17.115/17.255/17.396/0.140 ms
</pre>

h2. Desde el host, utiliza ssh -A, para acceder al router y posteriormente a los contenedores y a la máquina servidorNAS.



1. Desde mi host al router:

<pre>

madandy@toyota-hilux:~$ ssh -A router 
Linux router-andy 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Oct  4 13:41:51 2024 from 172.22.7.202
user@router-andy:~$ 



</pre>


2. Desde el host a los contenedores:


- ServidorWeb
<pre>

madandy@toyota-hilux:~$ ssh -A servidorWeb 
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.1.0-26-amd64 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro
Last login: Fri Oct  4 10:12:31 2024 from 192.168.200.1
root@servidorWeb:~# 


</pre>

- ServidorDHCP

<pre>


madandy@toyota-hilux:~$ ssh -A servidorDHCP 
Linux servidorDHCP 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Oct  4 12:14:24 2024 from 192.168.200.1
root@servidorDHCP:~# 


</pre>



h2. Busca información sobre la configuración de ssh para definir distintos accesos. Configura el fichero ~/.ssh/config en tu equipo para que puedas acceder desde el host directamente a los contenedores y a la máquina servidorNAS..

Archivo de configuración *.ssh/config*:


<pre>
madandy@toyota-hilux:~$ cat .ssh/config 
Host router
  HostName  172.22.6.245
  User user 
  ForwardAgent yes


Host servidorNAS
  HostName 192.168.200.2
  User user
  ForwardAgent yes
  ProxyJump router

Host servidorDHCP
  HostName 192.168.200.3
  User root
  ForwardAgent yes
  ProxyJump router

Host servidorWeb
  HostName 192.168.200.4
  User root
  ForwardAgent yes
  ProxyJump router

</pre>

Una vez esto lo que tendremos que hacer sera la comprobación de la conexión directa ya que lo que hemos establecido es es que pegue el salto directamente a los contendores(servidorWeb, servidorDHCP), como al servidorNAS.

- Desde mi host al router:

<pre>

madandy@toyota-hilux:~$ ssh router 
Linux router-andy 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Oct  4 12:07:36 2024
user@router-andy:~$ ip a
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
    inet 172.22.6.245/16 brd 172.22.255.255 scope global dynamic enp2s0
       valid_lft 75881sec preferred_lft 75881sec
    inet6 fe80::5054:ff:fe9b:9f6a/64 scope link 
       valid_lft forever preferred_lft forever
user@router-andy:~$ 
</pre>

- Desde el host al servidorNAS

<pre>

madandy@toyota-hilux:~$ ssh servidorNAS 
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

nas-andy:~$ 

</pre>

- ServidorWeb

<pre>

madandy@toyota-hilux:~$ ssh -A servidorWeb 
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.1.0-26-amd64 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro
Last login: Fri Oct  4 10:12:31 2024 from 192.168.200.1
root@servidorWeb:~# 

</pre>

- ServidorDHCP

<pre>
madandy@toyota-hilux:~$ ssh -A servidorDHCP 
Linux servidorDHCP 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Oct  4 12:14:24 2024 from 192.168.200.1
root@servidorDHCP:~# 

</pre>