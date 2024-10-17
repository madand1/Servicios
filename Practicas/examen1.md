h2. ejercicio 1

Entrada de ssh al cliente
<pre>
madandy@toyota-hilux:~$ ssh debian@192.168.122.221
Linux cliente-prueba 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Oct 17 08:28:33 2024 from 192.168.122.1
debian@cliente-prueba:~$ df -h
S.ficheros     Tamaño Usados  Disp Uso% Montado en
udev             962M      0  962M   0% /dev
tmpfs            197M   520K  197M   1% /run
/dev/sda1        4,9G   1,3G  3,4G  27% /
tmpfs            984M      0  984M   0% /dev/shm
tmpfs            5,0M      0  5,0M   0% /run/lock
tmpfs            197M      0  197M   0% /run/user/1000
debian@cliente-prueba:~$ 

</pre>

Se hizo a traves del script

<pre>
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios$ sudo ./crear_clientes.sh 
Introduce el nombre de la máquina: cliente-prueba
Introduce el tamaño del volumen (ejemplo: 10G): 6G
Introduce el nombre de la red: default
Formatting '/var/lib/libvirt/images/cliente-prueba.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=6442450944 backing_file=/var/lib/libvirt/images/planitilla-practica1-reducida.qcow2 backing_fmt=qcow2 lazy_refcounts=off refcount_bits=16
[   0.0] Examining /var/lib/libvirt/images/planitilla-practica1-reducida.qcow2
**********

Summary of changes:

virt-resize: /dev/sda1: This partition will be resized from 2.0G to 5.0G.  
The filesystem ext4 on /dev/sda1 will be expanded using the ‘resize2fs’ 
method.

virt-resize: /dev/sda2: This partition will be left alone.

**********
[   3.8] Setting up initial partition table on /var/lib/libvirt/images/cliente-prueba.qcow2
[   5.1] Copying /dev/sda1
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ --:--
[   8.1] Copying /dev/sda2
[  10.8] Expanding /dev/sda1 using the ‘resize2fs’ method

virt-resize: Resize operation completed with no errors.  Before deleting 
the old disk, carefully check that the resized disk boots and works 
correctly.
[   0.0] Examining the guest ...
[   3.5] Setting a random seed
[   3.5] Setting the hostname: cliente-prueba
[   4.0] SSH key inject: debian
[   4.4] Running: echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
[   4.4] Running: echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
[   4.5] Running: echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config
[   4.5] Running: ssh-keygen -A
[   5.2] Running: systemctl enable ssh
[   5.3] Running: systemctl start ssh
[   5.3] Running: mkdir -p /home/debian/.ssh
[   5.4] Running: chmod 700 /home/debian/.ssh
[   5.4] Running: chmod 600 /home/debian/.ssh/authorized_keys
[   5.4] Running: chown -R debian:debian /home/debian/.ssh
[   5.4] Running: echo -e "auto ens3\niface ens3 inet dhcp" >> /etc/network/interfaces
[   5.5] Running: ifup ens3
ssh-keygen: generating new host keys: RSA ECDSA ED25519 
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh
Running in chroot, ignoring command 'start'
Internet Systems Consortium DHCP Client 4.4.3-P1
Copyright 2004-2022 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Cannot find device "ens3"
Failed to get interface index: No such device

If you think you have received this message due to a bug rather
than a configuration issue please read the section on submitting
bugs on either our web page at www.isc.org or in the README file
before submitting a bug.  These pages explain the proper
process and the information we find helpful for debugging.

exiting.
ifup: failed to bring up ens3
virt-customize: error: ifup ens3: command exited with an error

If reporting bugs, run virt-customize with debugging enabled and include 
the complete output:

  virt-customize -v -x [...]
WARNING  Using --osinfo generic, VM performance may suffer. Specify an accurate OS for optimal results.

Empezando la instalación...
Creando dominio...                                          |    0 B  00:00     
Creación de dominio completada.
error: El dominio ya se encuentra activo

Máquina cliente-prueba creada y en ejecución.
</pre>

h2. ejercicio 2

h3. pregunta 1
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
    inet 10.0.0.1/16 brd 10.0.255.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe96:b5d0/64 scope link 
       valid_lft forever preferred_lft forever
3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:9b:9f:6a brd ff:ff:ff:ff:ff:ff
    inet 172.22.3.69/16 brd 172.22.255.255 scope global dynamic enp2s0
       valid_lft 84240sec preferred_lft 84240sec
    inet6 fe80::5054:ff:fe9b:9f6a/64 scope link 
       valid_lft forever preferred_lft forever
4: enp8s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:c3:17:09 brd ff:ff:ff:ff:ff:ff
    inet 172.16.0.1/16 brd 172.16.255.255 scope global enp8s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec3:1709/64 scope link 
       valid_lft forever preferred_lft forever

</pre>

<pre>
user@router-andy:~$ ip route sh
default via 172.22.0.1 dev enp2s0 
10.0.0.0/16 dev enp1s0 proto kernel scope link src 10.0.0.1 
172.16.0.0/16 dev enp8s0 proto kernel scope link src 172.16.0.1 
172.22.0.0/16 dev enp2s0 proto kernel scope link src 172.22.3.69 

</pre>

h3. pregunta2 

<pre>
debian@Cliente1-andy:~$ ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:56:fa:0b brd ff:ff:ff:ff:ff:ff
    inet 10.0.128.103/16 brd 10.0.255.255 scope global dynamic enp7s0
       valid_lft 10sec preferred_lft 10sec
    inet6 fe80::5054:ff:fe56:fa0b/64 scope link 
       valid_lft forever preferred_lft forever

</pre>

<pre>

subnet 10.0.0.0 netmask 255.255.0.0 {
    range 10.0.0.3 10.0.255.254;   # Rango de direcciones IP
    option routers 10.0.0.1;           # Puerta de enlace predeterminada
    option subnet-mask 255.255.0.0;       # Máscara de red
    option domain-name-servers 172.22.0.1;  # Servidor DNS
}

subnet 172.16.0.0 netmask 255.255.0.0 {
    default-lease-time 3600;
    range 172.16.0.3 172.16.255.254;   # Rango de direcciones IP
    option routers 172.16.0.1;           # Puerta de enlace predeterminada
    option domain-name-servers 172.22.0.1;  # Servidor DNS
}


</pre>

h3. Pregunta 3

<pre>
debian@Cliente1-andy:~$ ping -c 3 www.google.es
PING www.google.es (64.233.180.94) 56(84) bytes of data.
64 bytes from pe-in-f94.1e100.net (64.233.180.94): icmp_seq=1 ttl=97 time=99.2 ms
64 bytes from on-in-f94.1e100.net (64.233.180.94): icmp_seq=2 ttl=97 time=99.5 ms
64 bytes from on-in-f94.1e100.net (64.233.180.94): icmp_seq=3 ttl=97 time=99.3 ms

--- www.google.es ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 99.215/99.341/99.536/0.139 ms
debian@Cliente1-andy:~$ 

</pre>

