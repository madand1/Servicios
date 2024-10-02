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



