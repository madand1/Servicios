# Taller 1

```
madandy@toyota-hilux:~$ 
sudo apt install python3-openstackclient -y
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
python3-openstackclient ya está en su versión más reciente (6.0.0-4).
Los paquetes indicados a continuación se instalaron de forma automática y ya no son necesarios.
  augeas-lenses db-util hfsplus icoutils kpartx ldmtool libafflib0v5
  libaugeas0 libbfio1 libconfig9 libdate-manip-perl libewf2
  libfreerdp-server2-2 libfreerdp2-2 libhfsp0 libhivex0 libintl-perl
  libintl-xs-perl libldm-1.0-0 libnetpbm11 libntfs-3g89
  libstring-shellquote-perl libswscale6 libsys-virt-perl libtsk19
  libtss2-tctildr0 libvhdi1 libvmdk1 libwin-hivex-perl libwinpr2-2 libyara9
  linux-headers-6.1.0-27-amd64 linux-headers-6.1.0-27-common
  linux-image-6.1.0-27-amd64 lsscsi netpbm scrub sleuthkit supermin syslinux
  zerofree
Utilice «sudo apt autoremove» para eliminarlos.
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 18 no actualizados.
madandy@toyota-hilux:~$ 
openstack --version
openstack 6.0.0

```

- **Lista de instancias:**

madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack server list
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
| ID                                   | Name              | Status | Networks                                    | Image              | Flavor    |
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
| b73ad755-01bd-4a4e-8be5-b8e194b3c5a7 | Prueba-taller1-OS | ACTIVE | Red de amorgon204=10.0.0.67, 172.22.201.234 | Debian 12 Bookworm | m1.normal |
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
(os)$ openstack keypair list
bash: error sintáctico cerca del elemento inesperado `$'
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack keypair list


- **Lista de claves de pares**

madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack keypair list

madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack keypair list
+--------+-------------------------------------------------+------+
| Name   | Fingerprint                                     | Type |
+--------+-------------------------------------------------+------+
| Andres | 75:e7:4b:1f:95:68:c0:ce:52:27:d4:f6:76:ec:f2:5f | ssh  |

- **Grupo de seguridad**

1. Tiene con anterioridad:

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack security group rule list default
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+
| ID                                   | IP Protocol | Ethertype | IP Range  | Port Range | Direction | Remote Security Group                | Remote Address Group |
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+
| 0fcac5b2-b7c5-4e68-bac0-1fc5fcd8e19c | None        | IPv6      | ::/0      |            | egress    | None                                 | None                 |
| 818b9435-b31f-4fff-ba16-5cc1d9886f69 | None        | IPv4      | 0.0.0.0/0 |            | egress    | None                                 | None                 |
| 8ee19c4c-eae4-415f-9c38-520bce8e89af | None        | IPv4      | 0.0.0.0/0 |            | ingress   | 52c8e408-fa9b-4309-9ecf-a5a665e8d1ac | None                 |
| eee84393-83cc-4596-bba9-224d7b2510b3 | None        | IPv6      | ::/0      |            | ingress   | 52c8e408-fa9b-4309-9ecf-a5a665e8d1ac | None                 |
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 

```

- **Abriendo el puesto 443**

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack security group rule list default
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+
| ID                                   | IP Protocol | Ethertype | IP Range  | Port Range | Direction | Remote Security Group                | Remote Address Group |
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+
| 0fcac5b2-b7c5-4e68-bac0-1fc5fcd8e19c | None        | IPv6      | ::/0      |            | egress    | None                                 | None                 |
| 818b9435-b31f-4fff-ba16-5cc1d9886f69 | None        | IPv4      | 0.0.0.0/0 |            | egress    | None                                 | None                 |
| 8ee19c4c-eae4-415f-9c38-520bce8e89af | None        | IPv4      | 0.0.0.0/0 |            | ingress   | 52c8e408-fa9b-4309-9ecf-a5a665e8d1ac | None                 |
| 9bc4a335-ec08-4c63-9d95-e886b9ec4bdb | tcp         | IPv4      | 0.0.0.0/0 | 443:443    | ingress   | None                                 | None                 |
| eee84393-83cc-4596-bba9-224d7b2510b3 | None        | IPv6      | ::/0      |            | ingress   | 52c8e408-fa9b-4309-9ecf-a5a665e8d1ac | None                 |
+--------------------------------------+-------------+-----------+-----------+------------+-----------+--------------------------------------+----------------------+

```

**Subida de imagen de cirros**

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack image create --container-format=bare --disk-format=qcow2 \
 --file cirros-0.6.2-x86_64-disk.img "Cirros 0.6.2"
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                            |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------+
| container_format | bare                                                                                                                                             |
| created_at       | 2024-12-03T08:15:03Z                                                                                                                             |
| disk_format      | qcow2                                                                                                                                            |
| file             | /v2/images/ec1c2230-3e7b-469c-856c-6e715a0501a1/file                                                                                             |
| id               | ec1c2230-3e7b-469c-856c-6e715a0501a1                                                                                                             |
| min_disk         | 0                                                                                                                                                |
| min_ram          | 0                                                                                                                                                |
| name             | Cirros 0.6.2                                                                                                                                     |
| owner            | b336d672575846eab6d9b12320abc89b                                                                                                                 |
| properties       | os_hidden='False', owner_specified.openstack.md5='', owner_specified.openstack.object='images/Cirros 0.6.2', owner_specified.openstack.sha256='' |
| protected        | False                                                                                                                                            |
| schema           | /v2/schemas/image                                                                                                                                |
| status           | queued                                                                                                                                           |
| tags             |                                                                                                                                                  |
| updated_at       | 2024-12-03T08:15:03Z                                                                                                                             |
| visibility       | shared                                                                                                                                           |
+------------------+--------------------------------------------------------------------------------------------------------------------------------------------------+

```

- **Listado de imagenes**

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack image list
+--------------------------------------+---------------------------------+--------+
| ID                                   | Name                            | Status |
+--------------------------------------+---------------------------------+--------+
| ec1c2230-3e7b-469c-856c-6e715a0501a1 | Cirros 0.6.2                    | active |
| e7caa035-5bb0-47fb-b9e8-ef73dce54499 | Debian 12 Bookworm              | active |
| 1a39c3de-cf79-4d17-a470-a490ba89b366 | Fedora-Cloud-Base-37-1.7.x86_64 | active |
| 52f6e1bd-edc0-49e8-87e2-c99a3f173d41 | Rocky Linux 9                   | active |
| d57c4744-177a-4f53-8db9-6368dc17f979 | Ubuntu 22.04 LTS                | active |
| e2cfdd56-7474-4772-a43c-ad0429f4b78e | Ubuntu 24.04 LTS                | active |
| ffebc834-5c2f-4319-b5b8-a0c360050d4f | cirros-0.6.2-x86_64-disk        | active |
+--------------------------------------+---------------------------------+--------+

``` 

- **Listar los sabores**

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack flavor list
+----+------------+------+------+-----------+-------+-----------+
| ID | Name       |  RAM | Disk | Ephemeral | VCPUs | Is Public |
+----+------------+------+------+-----------+-------+-----------+
| 10 | vol.medium | 2048 |    0 |         0 |     2 | True      |
| 11 | vol.large  | 4096 |    0 |         0 |     2 | True      |
| 12 | vol.xlarge | 8192 |    0 |         0 |     4 | True      |
| 2  | m1.micro   |  256 |   10 |         0 |     1 | True      |
| 3  | m1.mini    |  512 |   10 |         0 |     1 | True      |
| 4  | m1.normal  | 1024 |   10 |         0 |     1 | True      |
| 5  | m1.medium  | 2048 |   20 |         0 |     2 | True      |
| 6  | m1.large   | 4096 |   20 |         0 |     2 | True      |
| 7  | m1.xlarge  | 8192 |   20 |         0 |     4 | True      |
| 8  | vol.mini   |  512 |    0 |         0 |     1 | True      |
| 9  | vol.normal | 1024 |    0 |         0 |     1 | True      |
+----+------------+------+------+-----------+-------+-----------+
```

- **Fichero de configuración**
```
- madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
cat prueba-taller1.yaml 
#cloud-config
# Actualiza los paquetes
package_update: true
package_upgrade: true
# Instala el paquete apache2
packages:
  - apache2
# Configura el hostname y el fqdn
fqdn: maquina.example.org
hostname: maquina
manage_etc_hosts: true
# Crear dos usuarios, configura el acceso por sudo y añade clave pública ssh
users:
  - name: jose
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys: 
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmjoVIoZCx4QFXvljqozXGqxxlSvO7V2aizqyPgMfGqnyl0J9YXo6zrcWYwyWMnMdRdwYZgHqfiiFCUn2QDm6ZuzC4Lcx0K3ZwO2lgL4XaATykVLneHR1ib6RNroFcClN69cxWsdwQW6dpjpiBDXf8m6/qxVP3EHwUTsP8XaOV7WkcCAqfYAMvpWLISqYme6e+6ZGJUIPkDTxavu5JTagDLwY+py1WB53eoDWsG99gmvyit2O1Eo+jRWN+mgRHIxJTrFtLS6o4iWeshPZ6LvCZ/Pum12Oj4B4bjGSHzrKjHZgTwhVJ/LDq3v71/PP4zaI3gVB9ZalemSxqomgbTlnT jose@debiane
  - name: andy
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys: 
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC00lFf6Jyj2o41CRmIrIvguHHYKfaByakRVvyoVjfTyZDxDA5PIsAW0JHAKW9V2+MMREjAeY74LiDMJlyc1XHSkEFmzrKXLQ9d8M81WV9vYh2aOB3yHWZq3/CwxpHgcgatlTRKaP310y4mfsbkdbuDAcgE7jwO0k6KlibpUSIet2bUXZ3zagrMNhmDrHErYh+ARW37cm2+OqQdv1l+GeOBlFCTC6yAsOdpbJ5VQ0fWwvR6bl5DUpGBr0RDWE7HQLHGt3WE2nNKCii+myzGc17kU1ERfi7C2aI80VWdQMPqwLUpam/TdNahvw1tZ3lkrjSHVS330Ll7T+uT8WXU4dHEgtlgSNEHszxrQoQcAv+KYzkzi7oMi42xEpdW378WeKcEHgcaKK+gIqR1UHBI8cfOYiduMbnqcySaSEs3YIAk3MaBtSBn4GkkMFWaYNzUK2Ic5MQIOZ/ZkQyzDYLfpVcf6i42bHTLkJvR1mNSDYiL6M3xAp76ws/3ETx0OcdiAf0= madandy@toyota-hilux
# Cambia las contraseña a los usuarios creados
chpasswd:
  expire: False
  users:
    - name: root
      password: password
      type: text
    - name: jose
      password: jose
      type: text
    - name: andy
      password: andy
      type: text
```

Y ahora entramos:
Pequeño recordatorio abrir el puerto 22.

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
ssh andy@172.22.200.213
The authenticity of host '172.22.200.213 (172.22.200.213)' can't be established.
ED25519 key fingerprint is SHA256:Avx5DScInMId8I6aAZaucwmEM1PmGeHqoHTcka52pYk.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '172.22.200.213' (ED25519) to the list of known hosts.
Linux maquina 6.1.0-28-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.119-1 (2024-11-22) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Dec  3 08:33:30 2024
andy@maquina:~$ 

```

- **Desconexion y vista de las ips flotantes**

```
andy@maquina:~$ 
logout
Connection to 172.22.200.213 closed.
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack floating ip list
+--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
| ID                                   | Floating IP Address | Fixed IP Address | Port                                 | Floating Network                     | Project                          |
+--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
| 0c991bb2-e0ed-4174-88af-de23756a09ac | 172.22.200.213      | 10.0.0.133       | 5b4b22b2-28d9-49b9-a1ba-a0732a7dbf02 | 98d3f685-e398-43fa-812f-80c90371269d | b336d672575846eab6d9b12320abc89b |
| df8bf75b-2394-41a2-8370-7afccb8a1ed2 | 172.22.201.234      | 10.0.0.67        | 05cd4d90-0a28-405f-ab8a-6d166f7bd024 | 98d3f685-e398-43fa-812f-80c90371269d | b336d672575846eab6d9b12320abc89b |
+--------------------------------------+---------------------+------------------+--------------------------------------+--------------------------------------+----------------------------------+
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 

```

- **Borrado y comprobación**

```

madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack server delete Prueba
```

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 
openstack server list
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
| ID                                   | Name              | Status | Networks                                    | Image              | Flavor    |
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
| b73ad755-01bd-4a4e-8be5-b8e194b3c5a7 | Prueba-taller1-OS | ACTIVE | Red de amorgon204=10.0.0.67, 172.22.201.234 | Debian 12 Bookworm | m1.normal |
+--------------------------------------+-------------------+--------+---------------------------------------------+--------------------+-----------+
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/uNIDAD4-openstack$ 

```