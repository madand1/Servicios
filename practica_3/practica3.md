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
└── ansible-playbook/                    # Directorio principal del playbook de Ansible
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

