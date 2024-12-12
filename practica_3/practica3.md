# Práctica (1 / 3): Creación y configuración de un servidor LAMP

Lo primero que haremos sera el fichero de Vagrantfile, que esta en la siguiente fichero : *Vagrantfile*

Tiene el diguiente contenido:

```
Vagrant.configure("2") do |config|

    config.vm.define :router do |router|
      router.vm.box = "debian/bookworm64" 
      router.vm.hostname = "router" 
      router.vm.synced_folder ".", "/vagrant", disabled: true
      router.vm.network :public_network,
        :dev => "br0",
        :mode => "bridge",
        :type => "bridge" 
      router.vm.network :private_network,
        :libvirt__network_name => "red_intra",
        :libvirt__dhcp_enabled => false,
        :ip => "10.0.0.1",
        :libvirt__forward_mode => "veryisolated" 
    end

    config.vm.define :web do |web|
      web.vm.box = "debian/bookworm64" 
      web.vm.hostname = "web" 
      web.vm.synced_folder ".", "/vagrant", disabled: true
      web.vm.network :private_network,
        :libvirt__network_name => "red_intra",
        :libvirt__dhcp_enabled => false,
        :ip => "10.0.0.2",
        :libvirt__forward_mode => "veryisolated" 
      web.vm.network :private_network,
        :libvirt__network_name => "red_datos",
        :libvirt__dhcp_enabled => false,
        :ip => "20.0.0.2",
        :libvirt__forward_mode => "veryisolated" 
    end

    config.vm.define :bd do |bd|
      bd.vm.box = "debian/bookworm64" 
      bd.vm.hostname = "web" 
      bd.vm.synced_folder ".", "/vagrant", disabled: true
      bd.vm.network :private_network,
        :libvirt__network_name => "red_intra",
        :libvirt__dhcp_enabled => false,
        :ip => "10.0.0.3",
        :libvirt__forward_mode => "veryisolated" 
      bd.vm.network :private_network,
        :libvirt__network_name => "red_datos",
        :libvirt__dhcp_enabled => false,
        :ip => "20.0.0.3",
        :libvirt__forward_mode => "veryisolated" 
    end

    config.vm.define :san do |san|
      san.vm.box = "debian/bookworm64" 
      san.vm.hostname = "san" 
      san.vm.synced_folder ".", "/vagrant", disabled: true
      san.vm.network :private_network,
        :libvirt__network_name => "red_intra",
        :libvirt__dhcp_enabled => false,
        :ip => "10.0.0.4",
        :libvirt__forward_mode => "veryisolated" 
      san.vm.network :private_network,
        :libvirt__network_name => "red_datos",
        :libvirt__dhcp_enabled => false,
        :ip => "20.0.0.4",
        :libvirt__forward_mode => "veryisolated" 
      san.vm.provider :libvirt do |libvirt|
        libvirt.storage :file, :size => '2G'
        libvirt.storage :file, :size => '2G'
        libvirt.storage :file, :size => '2G'
      end
    end
  end

```

Aqui os dejo el desglose:


Aquí te va la explicación como si fuéramos unos máquinas en informática callejera:

1. Primero lo primero: esto es un archivo de configuración de Vagrant. Vagrant es una herramienta pa’ crear máquinas virtuales fácil y rápido, como en plan "pilla la caja, suéltala y que tire". Aquí usamos la caja de Debian, versión "bookworm64", pa’ montar varias máquinas virtuales con una configuración to’ wapa.

2. Vagrant.configure("2"): esto es como decir "¡dale, Vagrant, configúrame esto con la versión 2 de tu sistema!". El "2" es pa' decirle qué versión de configuración estamos usando, ¿entiendes?

3. Máquina "router":

- Aquí creamos una máquina que se llama "router". Esta hace el curro de conectarlo todo, en plan jefe del barrio.

- router.vm.box = "debian/bookworm64": Le decimos que se baje la caja Debian, que es como el SO base de esta máquina.

- router.vm.hostname = "router": le ponemos nombre pa' que se sepa cuál es el router.
Sin sincronización de carpetas: router.vm.synced_folder está desactivado, porque aquí no queremos compartir archivos con el host.

- Red pública: el router va en public_network pa' conectarse fuera de la red de máquinas. Es decir, si fuera la vida real, el router se conecta al WiFi del barrio y también conecta a todas las otras máquinas.

- Red privada: conecta con la red privada llamada red_intra, como una calle solo pa’ la familia (las otras máquinas virtuales). La IP del router aquí es 10.0.0.1.

4. Máquina "web":

- Esta es la máquina que hace de servidor web, como el notas que va a mostrarte las páginas.

- Le ponemos IPs pa' que esté en la misma red privada que el router (10.0.0.2 en red_intra) y en otra red que se llama red_datos (20.0.0.2), pa' compartir cosas con otras máquinas sin salir del barrio.

5. Máquina "bd" (Base de datos):

- Esta máquina va a guardar la base de datos, como si fuera el que se guarda todos los contactos y registros de la peña.

- También va en red_intra (IP: 10.0.0.3) y en red_datos (IP: 20.0.0.3), pa' que solo los que están en el grupo privado puedan hablar con él.

6. Máquina "san" (Storage Area Network o "discos pa’ guardar de todo"):

- Aquí es donde se guardan cosas, como el garaje lleno de trastos. Tiene discos adicionales pa' guardar más cosas.

- Va en las mismas redes privadas que los otros, pero además le configuramos discos pa’ almacenamiento: libvirt.storage :file, :size => '2G' significa que le añadimos discos de 2GB cada uno.


Entonces, bro, lo que hace este código es montarte un tinglao con cuatro máquinas virtuales:

- Router que conecta todo.
- Web que sirve las páginas.
- Base de datos que guarda info.
- SAN que tiene espacio extra pa' guardar de to'.
- Cada una con sus conexiones pa' que se puedan pasar info en la red   interna sin que nadie externo pueda cotillear.

## Preguntas

1. Entrega una captura de pantalla accediendo por ssh a la máquina router:

- No uses vagrant ssh, es decir sin hacer conexiones a eth0.

Para esto usaremos el siguiente comando:

```
ssh -i .vagrant/machines/router/libvirt/private_key  vagrant@172.22.6.153
```

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/practica_3$  ssh -i .vagrant/machines/router/libvirt/private_key  vagrant@172.22.6.153
router/
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/practica_3$  ssh -i .vagrant/machines/router/libvirt/private_key  vagrant@172.22.6.153
Linux router 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Oct 29 08:33:05 2024 from 192.168.121.1
vagrant@router:~$ 

```

2. ¿Puedes acceder con ssh a las demás máquinas internas?

No podremos acceder a las internas por aque nos falta la privatekey


3. Comprobación que el servidor san tiene los discos que hemos configurado.

Entraremos por el siguiente comando:

```vagrant ssh san```

Y observaremos los discos que tenemos con el comando ```lsblk```

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/practica_3$ vagrant ssh san
Linux san 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
vagrant@san:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vdb    254:16   0    2G  0 disk 
vdc    254:32   0    2G  0 disk 
vdd    254:48   0    2G  0 disk 

```
# Práctica (2 / 3): Creación y configuración de un servidor LAMP

Para esta parte nos esta pidiendo lo siguiente el ejercicio:

![Escenario](/practica_3/img/image.png)

Es lo que teniamos anteriormente montado, pero ahora lo vemos en imagen que será mil veces mejor.

Y con lo que nos centraremos en lo que nos pide, para ello lo primero que haremos será la creación de todas las carpetas , y archivos necesarios:

```
cd Servicios/practica_3
mkdir -p ansible-playbook/{roles/{commons,router,redinterna,web,mariadb}/{tasks,templates,files},group_vars}
touch ansible-playbook/{hosts.ini,playbook.yml,vars.yml}
```
Estructura de la práctica se quedaría de la siguiente manera:

# Estructura del Proyecto

```plaintext
Servicios/practica_3/
├── Vagrantfile                          # Archivo de configuración de Vagrant para el entorno virtual
├── practica3.md                         # Documentación o instrucciones de la práctica
└── ansible/                    # Directorio principal del playbook de Ansible
    ├── hosts.ini                        # Inventario de hosts para Ansible
    ├── playbook.yml                     # Playbook principal
    ├── vars.yml                         # Variables globales de configuración
    ├── group_vars/
    │   └── all.yml                      # Variables comunes a todos los nodos
    └── roles/                           # Directorio que contiene los roles de Ansible
        ├── commons/                     # Rol "commons" para configuraciones generales
        │   └── tasks/
        │       └── main.yml             # Tareas comunes para todos los nodos
        ├── router/                      # Rol "router" para configurar el nodo de enrutamiento
        │   └── tasks/
        │       └── main.yml             # Tareas específicas para configurar el router
        ├── redinterna/                  # Rol "redinterna" para la configuración de la red aislada
        │   └── tasks/
        │       └── main.yml             # Tareas para configurar la red privada
        ├── web/                         # Rol "web" para configurar el servidor web
        │   ├── tasks/
        │   │   └── main.yml             # Tareas específicas para el servidor web
        │   ├── templates/
        │   │   └── vhost.conf.j2        # Plantilla para el VirtualHost de Apache
        │   └── files/
        │       └── index.html           # Página web estática para el DocumentRoot
        └── mariadb/                     # Rol "mariadb" para la configuración de MariaDB
            └── tasks/
                └── main.yml             # Tareas específicas para configurar MariaDB
```

Una vez teniendo la estructura, esta no es la definitiva (la pondre más tarde), lo que haremos será ponerla en su lugar cada elemento y para esto lo vamso a ir desglosando y para que sirve cada una de las cosas, ¿entendido?

1. Primero que tenemos que tener en cuenta es lo siguiente:

- La máquina accede a internet por la interfaz conectada a br0.

>[!CAUTION]
El br0 cambiara depende de donde trabajemos, por lo que en el router tendremso que cambiar a donde a pumnta su ruta con el siguiente comando:

```sudo ip route add default via <ip-br0-host>```

Una vez hecho esto hacemos la comprobación de que todos nuestro escenario tiene conexión a internet.

A lo mejor nuestro iptables **no se guardaron** no se sabe el porque, por lo que al tenerlo en la receta, se encuentra alojado aqui:

```ansible/roles/router/tasks/main.yaml```

y tendremos que hacer la comprobación con el comando:

```sudo iptables -t nat -L -v```

2. Una vez hecho esto lo que haremos sera la configuracion de nuestra receta de ansible, de la siguiente manera:

- Router:
- Web
- mariadb
- san
En cada uno tendremos que irnos al apartado *tasks* y poner lo que necesitamos en este momento, o nos pide el ejercicio.

## Respuestas:

1. Entrega los ficheros de ansible que has generado, comprimidos en un zip.

2. Entrada captura de pantalla accediendo a alguna máquina interna sin usar vagrant ssh.
Para hacer esto lo que tendremos que hacer es asegurarnos de que la ip de br0 este bien en nuestro router, esto puede ser un coñazo si estamos trabajando desde 2 sitios, distintos:

Para que entremos por ssh, sin necesidad de *vagrant ssh <nombre>*, lo que tendremos que hacer es editar el siguiente fichero *.ssh/config*, pondremos lo siguiente:

```
madandy@toyota-hilux:~$ cat .ssh/config 
Host router
  HostName  172.22.6.32
  User vagrant
  ForwardAgent yes

Host web
  HostName 10.0.0.2
  User vagrant
  ForwardAgent yes
  ProxyJump router

Host bd
  HostName 10.0.0.3
  User vagrant
  ForwardAgent yes
  ProxyJump router

Host san
  HostName 10.0.0.4
  User vagrant
  ForwardAgent yes
  ProxyJump router
madandy@toyota-hilux:~$ 


```

Y ahora comprobamos si es posible entrar a nuestros dispositivos:

- ssh a router
  
```
madandy@toyota-hilux:~$ ssh router 
The authenticity of host '172.22.6.32 (172.22.6.32)' can't be established.
ED25519 key fingerprint is SHA256:fXHi1m3USJfeiGXHjldsRb2dtWtiyHwWy8WEmoYu2wA.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:155: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? ys
Please type 'yes', 'no' or the fingerprint: yes
Warning: Permanently added '172.22.6.32' (ED25519) to the list of known hosts.
Linux router 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Oct 31 09:51:05 2024 from 192.168.121.1
vagrant@router:~$ 


```

- shhh a san 

```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/Servicios/practica_3$ ssh san 
The authenticity of host '10.0.0.4 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:cFLA07xKEcFs0ZBW3bWGQzf7w4TULRha2X+F2C4aTMA.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:157: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.4' (ED25519) to the list of known hosts.
Linux san 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Oct 30 17:05:28 2024 from 192.168.121.1
vagrant@san:~$ 

```

- ssh a bd

```
madandy@toyota-hilux:~$ ssh bd
The authenticity of host '10.0.0.3 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:5gINUBgG0pudGJF6Rh/8av6fvnKjVW8EdzvA+qwNdIE.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:156: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.3' (ED25519) to the list of known hosts.
Linux bd 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Oct 30 17:05:33 2024 from 192.168.121.1
vagrant@bd:~$ 

```

- shh a web

```
madandy@toyota-hilux:~$ ssh web 
The authenticity of host '10.0.0.2 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:+pagEVvT76ld25qqDe3clsVC+XTjIX6IeLYljdT9+Oc.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:153: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.2' (ED25519) to the list of known hosts.
Linux web 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Oct 31 09:56:52 2024 from 192.168.121.1
vagrant@web:~$ 

```


3. Entrega capturas de pantalla donde se vean las puertas de enlaces de los equipos de la red interna.

Puertas de enlaces de la red interna, es decir, *maquina web, san y bd*   

- bd 

```
vagrant@bd:~$ ip route 
default via 10.0.0.1 dev eth1 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.3 
20.0.0.0/24 dev eth2 proto kernel scope link src 20.0.0.3 
192.168.121.0/24 
```

- san 

```
vagrant@san:~$ ip route 
default via 10.0.0.1 dev eth1 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.4 
20.0.0.0/24 dev eth2 proto kernel scope link src 20.0.0.4 
192.168.121.0/24 dev eth0 proto kernel scope link src 192.168.121.229 
```

- web

```
vagrant@web:~$ ip route 
default via 10.0.0.1 dev eth1 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.2 
20.0.0.0/24 dev eth2 proto kernel scope link src 20.0.0.2 
192.168.121.0/24 dev eth0 proto kernel scope link src 192.168.121.53 

```

4. Entrega capturas de pantalla donde se vean las máquinas haciendo ping al exterior.

- bd 

```
vagrant@bd:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=109 time=10.5 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=109 time=12.4 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=109 time=11.7 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=109 time=10.5 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 10.454/11.262/12.387/0.813 ms

```

- san 

```
vagrant@san:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=20.0 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=20.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=19.7 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=19.6 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 19.561/19.998/20.703/0.442 ms

```

- web

```
vagrant@web:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=56.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=20.5 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=20.1 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=19.8 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 19.820/29.165/56.155/15.584 ms


```


5. Entrega una captura de pantalla donde se vea un acceso a la página web alojada en la máquina web accediendo a practica-tunombre.dominio.algo. Entrega la línea de tu resolución estática en tu cliente para que funcione.
Para que se pueda ver la web desde fuera, lo quye tendremos que hacer es poner en nuestro archivo de configuracióbn */etc/hosts* y en el cual tendremo que poner la ip de eth1 del router, con el nombre que esta puesto en el fichero *vars/main.yaml* de web
```
madandy@toyota-hilux:~$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	toyota-hilux
172.22.8.205	biblioteca.andres.org
172.22.123.100    openstack.gonzalonazareno.org
172.22.201.196    www.sad.com
192.168.1.165   practica-belphumbattlemoon.site 	
#192.168.122.138	www.example.org
#192.168.122.138 www.iesgn.com
#192.168.122.138 www.departamentos.com
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
madandy@toyota-hilux:~$ 


```

Y se veria de la siguiente manera:

![Rayo Mcqueen](img/image_apache.png)

6. Entrega la instrucción y una prueba de funcionamiento para realizar una conexión desde la máquina web a la base de datos creada, usando el nombre bd-tunombre.dominio.algo.

Para esto lo que haremos sera habilitar el cliente remoto den mysql, para eso os dejo este link, y haremos lo siguiente:

- En el servidor web, tendremos que entrar en /etc/host y poner lo siguiente:

```
vagrant@web:~$ mysql -u usuario -p -h bd-andresmorales.site practica1

```

Con lo que tendremos esta respuesta por pantalla:

```
vagrant@web:~$ mysql -u usuario -p -h bd-andresmorales.site practica1
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 31
Server version: 10.11.6-MariaDB-0+deb12u1 Debian 12

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [practica1]> ^DBye

```

- Hemos podido entrar ya que si nos vamos a la estructura, y analizamos lo que es , el fichero */vars/main.yaml* pusimos lo siguiente que fue la creación tanto del usuario como de la base de datos que se usara:

```
db_name: practica1
db_user: usuario
db_password: usuario

```

7. Añade un nueva máquina llamada cliente conectada a la red_intra, configura el inventario de ansible y vuelve a pasar la receta para que esta máquina tenga acceso a internet.

Ruta:

```
vagrant@cliente1:~$ ip r
default via 10.0.0.1 dev eth1 
10.0.0.0/24 dev eth1 proto kernel scope link src 10.0.0.5 
192.168.121.0/24 dev eth0 proto kernel scope link src 192.168.121.118 
vagrant@cliente1:~$ 

```

salida a internet:

```
vagrant@cliente1:~$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=19.7 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=20.5 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=21.2 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=20.2 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms

```
Conexion a la puerta de enlace:

```
vagrant@cliente1:~$ ping 10.0.0.1
PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.539 ms
64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=1.05 ms
64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=1.22 ms

--- 10.0.0.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2012ms
rtt min/avg/max/mdev = 0.539/0.934/1.217/0.287 ms

```
Configuracion de ip

```
vagrant@cliente1:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:cf:37:3d brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    altname ens5
    inet 192.168.121.118/24 brd 192.168.121.255 scope global dynamic eth0
       valid_lft 2405sec preferred_lft 2405sec
    inet6 fe80::5054:ff:fecf:373d/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:2e:5e:5d brd ff:ff:ff:ff:ff:ff
    altname enp0s6
    altname ens6
    inet 10.0.0.5/24 brd 10.0.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe2e:5e5d/64 scope link 
       valid_lft forever preferred_lft forever

```

# Parte 3
## Servidor SAN

vagrant@san:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vdb    254:16   0    2G  0 disk 
vdc    254:32   0    2G  0 disk 
vdd    254:48   0    2G  0 disk 
vagrant@san:~$ sudo apt install mdadm -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  bsd-mailx exim4-base exim4-config exim4-daemon-light libevent-2.1-7
  libgnutls-dane0 libidn12 liblockfile1 libunbound8 psmisc
Suggested packages:
  exim4-doc-html | exim4-doc-info eximon4 spf-tools-perl swaks dns-root-data
  dracut-core
The following NEW packages will be installed:
  bsd-mailx exim4-base exim4-config exim4-daemon-light libevent-2.1-7
  libgnutls-dane0 libidn12 liblockfile1 libunbound8 mdadm psmisc
0 upgraded, 11 newly installed, 0 to remove and 0 not upgraded.
Need to get 4009 kB of archives.
After this operation, 9078 kB of additional disk space will be used.
Get:1 https://deb.debian.org/debian bookworm/main amd64 mdadm amd64 4.2-5 [443 kB]
Get:2 https://deb.debian.org/debian bookworm/main amd64 exim4-config all 4.96-15+deb12u5 [256 kB]
Get:3 https://deb.debian.org/debian bookworm/main amd64 exim4-base amd64 4.96-15+deb12u5 [1117 kB]
Get:4 https://deb.debian.org/debian bookworm/main amd64 libevent-2.1-7 amd64 2.1.12-stable-8 [180 kB]
Get:5 https://deb.debian.org/debian bookworm/main amd64 libunbound8 amd64 1.17.1-2+deb12u2 [550 kB]
Get:6 https://deb.debian.org/debian bookworm/main amd64 libgnutls-dane0 amd64 3.7.9-2+deb12u3 [406 kB]
Get:7 https://deb.debian.org/debian bookworm/main amd64 libidn12 amd64 1.41-1 [83.8 kB]
Get:8 https://deb.debian.org/debian bookworm/main amd64 exim4-daemon-light amd64 4.96-15+deb12u5 [605 kB]
Get:9 https://deb.debian.org/debian bookworm/main amd64 liblockfile1 amd64 1.17-1+b1 [17.0 kB]
Get:10 https://deb.debian.org/debian bookworm/main amd64 bsd-mailx amd64 8.1.2-0.20220412cvs-1 [90.4 kB]
Get:11 https://deb.debian.org/debian bookworm/main amd64 psmisc amd64 23.6-1 [259 kB]
Fetched 4009 kB in 0s (8275 kB/s)
Preconfiguring packages ...
Selecting previously unselected package mdadm.
(Reading database ... 30451 files and directories currently installed.)
Preparing to unpack .../00-mdadm_4.2-5_amd64.deb ...
Unpacking mdadm (4.2-5) ...
Selecting previously unselected package exim4-config.
Preparing to unpack .../01-exim4-config_4.96-15+deb12u5_all.deb ...
Unpacking exim4-config (4.96-15+deb12u5) ...
Selecting previously unselected package exim4-base.
Preparing to unpack .../02-exim4-base_4.96-15+deb12u5_amd64.deb ...
Unpacking exim4-base (4.96-15+deb12u5) ...
Selecting previously unselected package libevent-2.1-7:amd64.
Preparing to unpack .../03-libevent-2.1-7_2.1.12-stable-8_amd64.deb ...
Unpacking libevent-2.1-7:amd64 (2.1.12-stable-8) ...
Selecting previously unselected package libunbound8:amd64.
Preparing to unpack .../04-libunbound8_1.17.1-2+deb12u2_amd64.deb ...
Unpacking libunbound8:amd64 (1.17.1-2+deb12u2) ...
Selecting previously unselected package libgnutls-dane0:amd64.
Preparing to unpack .../05-libgnutls-dane0_3.7.9-2+deb12u3_amd64.deb ...
Unpacking libgnutls-dane0:amd64 (3.7.9-2+deb12u3) ...
Selecting previously unselected package libidn12:amd64.
Preparing to unpack .../06-libidn12_1.41-1_amd64.deb ...
Unpacking libidn12:amd64 (1.41-1) ...
Selecting previously unselected package exim4-daemon-light.
Preparing to unpack .../07-exim4-daemon-light_4.96-15+deb12u5_amd64.deb ...
Unpacking exim4-daemon-light (4.96-15+deb12u5) ...
Selecting previously unselected package liblockfile1:amd64.
Preparing to unpack .../08-liblockfile1_1.17-1+b1_amd64.deb ...
Unpacking liblockfile1:amd64 (1.17-1+b1) ...
Selecting previously unselected package bsd-mailx.
Preparing to unpack .../09-bsd-mailx_8.1.2-0.20220412cvs-1_amd64.deb ...
Unpacking bsd-mailx (8.1.2-0.20220412cvs-1) ...
Selecting previously unselected package psmisc.
Preparing to unpack .../10-psmisc_23.6-1_amd64.deb ...
Unpacking psmisc (23.6-1) ...
Setting up psmisc (23.6-1) ...
Setting up libidn12:amd64 (1.41-1) ...
Setting up libevent-2.1-7:amd64 (2.1.12-stable-8) ...
Setting up exim4-config (4.96-15+deb12u5) ...
Adding system-user for exim (v4)
Setting up liblockfile1:amd64 (1.17-1+b1) ...
Setting up mdadm (4.2-5) ...
Generating mdadm.conf... done.
update-initramfs: deferring update (trigger activated)
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.1.0-26-amd64
Found initrd image: /boot/initrd.img-6.1.0-26-amd64
Found linux image: /boot/vmlinuz-6.1.0-25-amd64
Found initrd image: /boot/initrd.img-6.1.0-25-amd64
done
update-rc.d: warning: start and stop actions are no longer supported; falling ba
ck to defaults
Created symlink /etc/systemd/system/sysinit.target.wants/mdadm-shutdown.service 
→ /lib/systemd/system/mdadm-shutdown.service.
Setting up exim4-base (4.96-15+deb12u5) ...
exim: DB upgrade, deleting hints-db
Created symlink /etc/systemd/system/timers.target.wants/exim4-base.timer → /lib/
systemd/system/exim4-base.timer.
exim4-base.service is a disabled or a static unit, not starting it.
Setting up libunbound8:amd64 (1.17.1-2+deb12u2) ...
Setting up libgnutls-dane0:amd64 (3.7.9-2+deb12u3) ...
Setting up exim4-daemon-light (4.96-15+deb12u5) ...
Setting up bsd-mailx (8.1.2-0.20220412cvs-1) ...
update-alternatives: using /usr/bin/bsd-mailx to provide /usr/bin/mailx (mailx) 
in auto mode
Processing triggers for libc-bin (2.36-9+deb12u8) ...
Processing triggers for man-db (2.11.2-2) ...
Processing triggers for initramfs-tools (0.142+deb12u1) ...
update-initramfs: Generating /boot/initrd.img-6.1.0-26-amd64
W: No zstd in /usr/bin:/sbin:/bin, using gzip
vagrant@san:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vdb    254:16   0    2G  0 disk 
vdc    254:32   0    2G  0 disk 
vdd    254:48   0    2G  0 disk 
vagrant@san:~$ sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/vdb /dev/vdc /dev/vdd
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: size set to 2094080K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
vagrant@san:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 vdd[3] vdc[1] vdb[0]
      4188160 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [===========>.........]  recovery = 58.0% (1215628/2094080) finish=0.0min speed=202604K/sec
      
unused devices: <none>
vagrant@san:~$ sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
ARRAY /dev/md0 metadata=1.2 name=san:0 UUID=3a280467:df3d6256:420531f7:cfef10ae
vagrant@san:~$ sudo update-initramfs -u
update-initramfs: Generating /boot/initrd.img-6.1.0-26-amd64
W: No zstd in /usr/bin:/sbin:/bin, using gzip
vagrant@san:~$ sudo pvcreate /dev/md0
sudo: pvcreate: command not found
vagrant@san:~$ sudo apt install lvm2
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  dmeventd libdevmapper-event1.02.1 liblvm2cmd2.03 thin-provisioning-tools
The following NEW packages will be installed:
  dmeventd libdevmapper-event1.02.1 liblvm2cmd2.03 lvm2
  thin-provisioning-tools
0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
Need to get 2434 kB of archives.
After this operation, 8954 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 https://deb.debian.org/debian bookworm/main amd64 libdevmapper-event1.02.1 amd64 2:1.02.185-2 [12.9 kB]
Get:2 https://deb.debian.org/debian bookworm/main amd64 liblvm2cmd2.03 amd64 2.03.16-2 [742 kB]
Get:3 https://deb.debian.org/debian bookworm/main amd64 dmeventd amd64 2:1.02.185-2 [59.2 kB]
Get:4 https://deb.debian.org/debian bookworm/main amd64 lvm2 amd64 2.03.16-2 [1229 kB]
Get:5 https://deb.debian.org/debian bookworm/main amd64 thin-provisioning-tools amd64 0.9.0-2 [391 kB]
Fetched 2434 kB in 1s (1833 kB/s)            
Selecting previously unselected package libdevmapper-event1.02.1:amd64.
(Reading database ... 30889 files and directories currently installed.)
Preparing to unpack .../libdevmapper-event1.02.1_2%3a1.02.185-2_amd64.deb ...
Unpacking libdevmapper-event1.02.1:amd64 (2:1.02.185-2) ...
Selecting previously unselected package liblvm2cmd2.03:amd64.
Preparing to unpack .../liblvm2cmd2.03_2.03.16-2_amd64.deb ...
Unpacking liblvm2cmd2.03:amd64 (2.03.16-2) ...
Selecting previously unselected package dmeventd.
Preparing to unpack .../dmeventd_2%3a1.02.185-2_amd64.deb ...
Unpacking dmeventd (2:1.02.185-2) ...
Selecting previously unselected package lvm2.
Preparing to unpack .../lvm2_2.03.16-2_amd64.deb ...
Unpacking lvm2 (2.03.16-2) ...
Selecting previously unselected package thin-provisioning-tools.
Preparing to unpack .../thin-provisioning-tools_0.9.0-2_amd64.deb ...
Unpacking thin-provisioning-tools (0.9.0-2) ...
Setting up libdevmapper-event1.02.1:amd64 (2:1.02.185-2) ...
Setting up thin-provisioning-tools (0.9.0-2) ...
Setting up liblvm2cmd2.03:amd64 (2.03.16-2) ...
Setting up dmeventd (2:1.02.185-2) ...
Created symlink /etc/systemd/system/sockets.target.wants/dm-event.socket → /lib/
systemd/system/dm-event.socket.
dm-event.service is a disabled or a static unit, not starting it.
Setting up lvm2 (2.03.16-2) ...
Created symlink /etc/systemd/system/sysinit.target.wants/blk-availability.servic
e → /lib/systemd/system/blk-availability.service.
Created symlink /etc/systemd/system/sysinit.target.wants/lvm2-monitor.service → 
/lib/systemd/system/lvm2-monitor.service.
Created symlink /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket → 
/lib/systemd/system/lvm2-lvmpolld.socket.
Processing triggers for initramfs-tools (0.142+deb12u1) ...
update-initramfs: Generating /boot/initrd.img-6.1.0-26-amd64
W: No zstd in /usr/bin:/sbin:/bin, using gzip
Processing triggers for libc-bin (2.36-9+deb12u8) ...
Processing triggers for man-db (2.11.2-2) ...
vagrant@san:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
vagrant@san:~$ sudo vgcreate vg_san /dev/md0
  Volume group "vg_san" successfully created
vagrant@san:~$ sudo lvcreate -L 2G -n lv_data1 vg_san
  Logical volume "lv_data1" created.
vagrant@san:~$ sudo lvcreate -L 2G -n lv_data1 vg_san
  Logical Volume "lv_data1" already exists in volume group "vg_san"
vagrant@san:~$ sudo mkfs.ext4 /dev/vg_san/lv_data1
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 524288 4k blocks and 131072 inodes
Filesystem UUID: 163bd2d8-6183-4de4-9282-6b23bf52b5bd
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

vagrant@san:~$ sudo apt install tgt -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  ibverbs-providers libconfig-general-perl libibverbs1 libnl-3-200
  libnl-route-3-200 librdmacm1 libsgutils2-1.46-2 sg3-utils
Suggested packages:
  tgt-glusterfs tgt-rbd
The following NEW packages will be installed:
  ibverbs-providers libconfig-general-perl libibverbs1 libnl-3-200
  libnl-route-3-200 librdmacm1 libsgutils2-1.46-2 sg3-utils tgt
0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
Need to get 1960 kB of archives.
After this operation, 6508 kB of additional disk space will be used.
Get:1 https://deb.debian.org/debian bookworm/main amd64 libnl-3-200 amd64 3.7.0-0.2+b1 [63.1 kB]
Get:2 https://deb.debian.org/debian bookworm/main amd64 libnl-route-3-200 amd64 3.7.0-0.2+b1 [185 kB]
Get:3 https://deb.debian.org/debian bookworm/main amd64 libibverbs1 amd64 44.0-2 [60.7 kB]
Get:4 https://deb.debian.org/debian bookworm/main amd64 librdmacm1 amd64 44.0-2 [68.6 kB]
Get:5 https://deb.debian.org/debian bookworm/main amd64 libconfig-general-perl all 2.65-2 [71.8 kB]
Get:6 https://deb.debian.org/debian bookworm/main amd64 libsgutils2-1.46-2 amd64 1.46-3 [117 kB]
Get:7 https://deb.debian.org/debian bookworm/main amd64 sg3-utils amd64 1.46-3 [845 kB]
Get:8 https://deb.debian.org/debian bookworm/main amd64 tgt amd64 1:1.0.85-1 [215 kB]
Get:9 https://deb.debian.org/debian bookworm/main amd64 ibverbs-providers amd64 44.0-2 [335 kB]
Fetched 1960 kB in 1s (1416 kB/s)      
Selecting previously unselected package libnl-3-200:amd64.
(Reading database ... 31103 files and directories currently installed.)
Preparing to unpack .../0-libnl-3-200_3.7.0-0.2+b1_amd64.deb ...
Unpacking libnl-3-200:amd64 (3.7.0-0.2+b1) ...
Selecting previously unselected package libnl-route-3-200:amd64.
Preparing to unpack .../1-libnl-route-3-200_3.7.0-0.2+b1_amd64.deb ...
Unpacking libnl-route-3-200:amd64 (3.7.0-0.2+b1) ...
Selecting previously unselected package libibverbs1:amd64.
Preparing to unpack .../2-libibverbs1_44.0-2_amd64.deb ...
Unpacking libibverbs1:amd64 (44.0-2) ...
Selecting previously unselected package librdmacm1:amd64.
Preparing to unpack .../3-librdmacm1_44.0-2_amd64.deb ...
Unpacking librdmacm1:amd64 (44.0-2) ...
Selecting previously unselected package libconfig-general-perl.
Preparing to unpack .../4-libconfig-general-perl_2.65-2_all.deb ...
Unpacking libconfig-general-perl (2.65-2) ...
Selecting previously unselected package libsgutils2-1.46-2:amd64.
Preparing to unpack .../5-libsgutils2-1.46-2_1.46-3_amd64.deb ...
Unpacking libsgutils2-1.46-2:amd64 (1.46-3) ...
Selecting previously unselected package sg3-utils.
Preparing to unpack .../6-sg3-utils_1.46-3_amd64.deb ...
Unpacking sg3-utils (1.46-3) ...
Selecting previously unselected package tgt.
Preparing to unpack .../7-tgt_1%3a1.0.85-1_amd64.deb ...
Unpacking tgt (1:1.0.85-1) ...
Selecting previously unselected package ibverbs-providers:amd64.
Preparing to unpack .../8-ibverbs-providers_44.0-2_amd64.deb ...
Unpacking ibverbs-providers:amd64 (44.0-2) ...
Setting up libconfig-general-perl (2.65-2) ...
Setting up libsgutils2-1.46-2:amd64 (1.46-3) ...
Setting up libnl-3-200:amd64 (3.7.0-0.2+b1) ...
Setting up sg3-utils (1.46-3) ...
Setting up libnl-route-3-200:amd64 (3.7.0-0.2+b1) ...
Setting up libibverbs1:amd64 (44.0-2) ...
Setting up ibverbs-providers:amd64 (44.0-2) ...
Setting up librdmacm1:amd64 (44.0-2) ...
Setting up tgt (1:1.0.85-1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/tgt.service → /lib/s
ystemd/system/tgt.service.
Processing triggers for man-db (2.11.2-2) ...
Processing triggers for libc-bin (2.36-9+deb12u8) ...
vagrant@san:~$ sudo nano /etc/tgt/conf.d/san.conf
vagrant@san:~$ cat /etc/tgt/conf.d/san.conf
cat: /etc/tgt/conf.d/san.conf: No such file or directory
vagrant@san:~$ sudo nano /etc/tgt/conf.d/san.conf
vagrant@san:~$ lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vagrant@san:~$ sudo nano /etc/tgt/conf.d/san.conf
vagrant@san:~$ sudo systemctl restart tgt
vagrant@san:~$ sudo tgtadm --mode target --op show
Target 1: iqn.2024-11.com.example:san.target1
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags: 
    Account information:
    ACL information:
        10.0.0.5
vagrant@san:~$ lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vagrant@san:~$ history
    1  ip a
    2  ping 8.8.8.8
    3  sudo nano /etc/network/interfaces
    4  ping 8.8.8.8
    5  sudo nano /etc/network/interfaces
    6  ping 8.8.8.8
    7  ping 10.0.0.1
    8  sudo reboot 
    9  lsblk 
   10  clear
   11  lsblk 
   12  sudo apt update
   13  lsblk
   14  clear
   15  lsblk
   16  sudo apt install mdadm -y
   17  lsblk
   18  sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/vdb /dev/vdc /dev/vdd
   19  cat /proc/mdstat
   20  sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
   21  sudo update-initramfs -u
   22  sudo pvcreate /dev/md0
   23  sudo apt install lvm2
   24  sudo pvcreate /dev/md0
   25  sudo vgcreate vg_san /dev/md0
   26  sudo lvcreate -L 2G -n lv_data1 vg_san
   27  sudo mkfs.ext4 /dev/vg_san/lv_data1
   28  sudo apt install tgt -y
   29  sudo nano /etc/tgt/conf.d/san.conf
   30  cat /etc/tgt/conf.d/san.conf
   31  sudo nano /etc/tgt/conf.d/san.conf
   32  lsblk
   33  sudo nano /etc/tgt/conf.d/san.conf
   34  sudo systemctl restart tgt
   35  sudo tgtadm --mode target --op show
   36  lsblk
   37  history
vagrant@san:~$ lsblk 
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  └─vg_san-lv_data1 253:0    0    2G  0 lvm   
vagrant@san:~$ cat /etc/tgt/conf.d/san.conf
<target iqn.2024-11.com.example:san.target1>
    backing-store /dev/md0
    initiator-address 10.0.0.5
</target>

vagrant@san:~$ sudo lvcreate -L 1G -n lv_linux vg_san
  Logical volume "lv_linux" created.
vagrant@san:~$ lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vagrant@san:~$ sudo nano /etc/tgt/conf.d/san.conf
vagrant@san:~$ sudo systemctl restart tgt
vagrant@san:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:2f:d0:cf brd ff:ff:ff:ff:ff:ff
    altname enp0s8
    altname ens8
    inet 192.168.121.193/24 brd 192.168.121.255 scope global dynamic eth0
       valid_lft 2487sec preferred_lft 2487sec
    inet6 fe80::5054:ff:fe2f:d0cf/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:2b:2f:e8 brd ff:ff:ff:ff:ff:ff
    altname enp0s9
    altname ens9
    inet 10.0.0.4/24 brd 10.0.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe2b:2fe8/64 scope link 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:18:c9:d7 brd ff:ff:ff:ff:ff:ff
    altname enp0s10
    altname ens10
    inet 20.0.0.4/24 brd 20.0.0.255 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe18:c9d7/64 scope link 
       valid_lft forever preferred_lft forever
vagrant@san:~$ lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vagrant@san:~$ 

### Para hacerlo persistente

vagrant@san:~$ lsblk 
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 253:0    0    2G  0 lvm   
  └─vg_san-lv_linux 253:1    0    1G  0 lvm   
vagrant@san:~$ sudo blkid
/dev/mapper/vg_san-lv_linux: UUID="12139e52-5183-48e5-8531-779734aa709c" BLOCK_SIZE="4096" TYPE="ext4"
/dev/vdd: UUID="3a280467-df3d-6256-4205-31f7cfef10ae" UUID_SUB="346949a2-4287-3916-061a-87853969c411" LABEL="san:0" TYPE="linux_raid_member"
/dev/vdb: UUID="3a280467-df3d-6256-4205-31f7cfef10ae" UUID_SUB="82864255-c686-3f0a-80a1-2fd17a54ea3c" LABEL="san:0" TYPE="linux_raid_member"
/dev/md0: UUID="wgGfwh-Dsy8-Nkrr-tXeZ-23ho-1DJC-Gc4lq1" TYPE="LVM2_member"
/dev/mapper/vg_san-lv_data1: UUID="163bd2d8-6183-4de4-9282-6b23bf52b5bd" BLOCK_SIZE="4096" TYPE="ext4"
/dev/vdc: UUID="3a280467-df3d-6256-4205-31f7cfef10ae" UUID_SUB="f0fec90e-6f4c-b93c-f153-2d4043d51bfa" LABEL="san:0" TYPE="linux_raid_member"
/dev/vda1: UUID="0e30d6ed-7c93-4b5b-953e-6bc4300f17f1" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="bf795a03-01"
vagrant@san:~$ sudo nano /etc/fstab
vagrant@san:~$ sudo mkdir -p /mnt/data1
vagrant@san:~$ sudo mkdir -p /mnt/linux
vagrant@san:~$ sudo mount -a
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
vagrant@san:~$ sudo systemctl daemon-reload
vagrant@san:~$ sudo mount -a
vagrant@san:~$ df -h
Filesystem                   Size  Used Avail Use% Mounted on
udev                         207M     0  207M   0% /dev
tmpfs                         46M  512K   46M   2% /run
/dev/vda1                     98G  1.7G   92G   2% /
tmpfs                        229M     0  229M   0% /dev/shm
tmpfs                        5.0M     0  5.0M   0% /run/lock
tmpfs                         46M     0   46M   0% /run/user/1000
/dev/mapper/vg_san-lv_data1  2.0G   24K  1.8G   1% /mnt/data1
/dev/mapper/vg_san-lv_linux  974M   24K  907M   1% /mnt/linux
vagrant@san:~$ cat /etc/fast
cat: /etc/fast: No such file or directory
vagrant@san:~$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# <file sys>	<mount point>	<type>	<options>	<dump>	<pass>

# device during installation: /dev/loop0p1
UUID=0e30d6ed-7c93-4b5b-953e-6bc4300f17f1	/	ext4	rw,discard,errors=remount-ro	01

#Volumen logico vg-san-lv-data1

UUID=163bd2d8-6183-4de4-9282-6b23bf52b5bd /mnt/data1 ext4 defaults 0 2

UUID=12139e52-5183-48e5-8531-779734aa709c /mnt/linux ext4 defaults 0 2


#VAGRANT-BEGIN
# The contents below are automatically generated by Vagrant. Do not modify.
#VAGRANT-END
vagrant@san:~$ sudo reboot

Broadcast message from root@san on pts/1 (Wed 2024-11-06 11:04:37 UTC):

The system will reboot now!

vagrant@san:~$ Connection to 10.0.0.4 closed by remote host.
Connection to 10.0.0.4 closed.
madandy@toyota-hilux:~$ ssh san 
Linux san 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Nov  6 08:49:57 2024 from 10.0.0.1
vagrant@san:~$ df -h
Filesystem                   Size  Used Avail Use% Mounted on
udev                         205M     0  205M   0% /dev
tmpfs                         46M  512K   46M   2% /run
/dev/vda1                     98G  1.7G   92G   2% /
tmpfs                        229M     0  229M   0% /dev/shm
tmpfs                        5.0M     0  5.0M   0% /run/lock
/dev/mapper/vg_san-lv_data1  2.0G   24K  1.8G   1% /mnt/data1
/dev/mapper/vg_san-lv_linux  974M   24K  907M   1% /mnt/linux
tmpfs                         46M     0   46M   0% /run/user/1000
vagrant@san:~$ lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda                 254:0    0  100G  0 disk  
└─vda1              254:1    0  100G  0 part  /
vdb                 254:16   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 252:0    0    2G  0 lvm   /mnt/data1
  └─vg_san-lv_linux 252:1    0    1G  0 lvm   /mnt/linux
vdc                 254:32   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 252:0    0    2G  0 lvm   /mnt/data1
  └─vg_san-lv_linux 252:1    0    1G  0 lvm   /mnt/linux
vdd                 254:48   0    2G  0 disk  
└─md0                 9:0    0    4G  0 raid5 
  ├─vg_san-lv_data1 252:0    0    2G  0 lvm   /mnt/data1
  └─vg_san-lv_linux 252:1    0    1G  0 lvm   /mnt/linux
vagrant@san:~$ 


## Cliente linux


vagrant@cliente1:~$ sudo apt update
Hit:1 https://deb.debian.org/debian bookworm InRelease                       
Hit:2 https://deb.debian.org/debian bookworm-updates InRelease               
Hit:3 https://deb.debian.org/debian bookworm-backports InRelease             
Hit:4 https://security.debian.org/debian-security bookworm-security InRelease
Reading package lists... Done                          
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
vagrant@cliente1:~$ sudo apt install open-iscsi -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
open-iscsi is already the newest version (2.1.8-1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
vagrant@cliente1:~$ sudo iscsiadm -m discovery -t sendtargets -p 10.0.0.4
10.0.0.4:3260,1 iqn.2024-11.com.example:san.target1
vagrant@cliente1:~$ sudo iscsiadm -m node -T iqn.2024-11.com.example:san.target1 -p 10.0.0.4 --login
Logging in to [iface: default, target: iqn.2024-11.com.example:san.target1, portal: 10.0.0.4,3260]
Login to [iface: default, target: iqn.2024-11.com.example:san.target1, portal: 10.0.0.4,3260] successful.
vagrant@cliente1:~$ sudo iscsiadm -m node -T iqn.2024-11.com.example:san.target1 -p 10.0.0.4 --op update --name node.startup --value automatic
vagrant@cliente1:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0    1G  0 disk 
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vagrant@cliente1:~$ sudo mkfs.ext4 /dev/sda
mke2fs 1.47.0 (5-Feb-2023)
/dev/sda contains a ext4 file system
	last mounted on Wed Nov  6 09:46:12 2024
Proceed anyway? (y,N) y
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 12139e52-5183-48e5-8531-779734aa709c
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

vagrant@cliente1:~$ sudo mkdir -p /mnt/san_lun
vagrant@cliente1:~$ sudo nano /etc/systemd/system/mnt-san_lun.mount
vagrant@cliente1:~$ sudo systemctl daemon-reload
vagrant@cliente1:~$ sudo systemctl enable mnt-san_lun.mount
vagrant@cliente1:~$ sudo systemctl start mnt-san_lun.mount
vagrant@cliente1:~$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0    1G  0 disk /mnt/san_lun
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vagrant@cliente1:~$ sudo reboot

Broadcast message from root@cliente1 on pts/1 (Wed 2024-11-06 10:55:41 UTC):

The system will reboot now!

vagrant@cliente1:~$ Connection to 10.0.0.5 closed by remote host.
Connection to 10.0.0.5 closed.
madandy@toyota-hilux:~$ ssh cliente1
Linux cliente1 6.1.0-26-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.112-1 (2024-09-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Nov  6 10:09:20 2024 from 10.0.0.1
vagrant@cliente1:~$ ls
ls           lsblk        lsinitramfs  lslocks      lsmod        lspci        
lsattr       lscpu        lsipc        lslogins     lsns         
lsb_release  lsfd         lsirq        lsmem        lsof         
vagrant@cliente1:~$ lsb
lsb_release  lsblk        
vagrant@cliente1:~$ lsblk 
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0    1G  0 disk 
vda    254:0    0  100G  0 disk 
└─vda1 254:1    0  100G  0 part /
vagrant@cliente1:~$ 
