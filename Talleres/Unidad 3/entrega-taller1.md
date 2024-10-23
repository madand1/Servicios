h1. Taller 1: Ansible - Playbook sencillo

h2. Entrega los ficheros: site.yaml, hosts y template/index.j2.

site.yaml

<pre>
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/taller_ansible_vagrant/Taller1$ cat site.yaml 
- hosts: all
  become: true
  tasks:
    # Actualizamos paquetes
    - name: Actualizamos el sistema
      apt: 
        update_cache: yes
        upgrade: yes

    # Instalar paquetes
    - name: "Instalar paquetes con apt"
      apt: 
        name: 
          - git
          - apache2
        state: present  

    # Copia un fichero a la máquina remota
    - name: "Copiar fichero a la máquina remota"
      copy:
        src: files/foo.conf
        dest: /etc/foo.txt   
        owner: root
        group: root
        mode: '0644'

    # Copia un template a un fichero
    - name: "Copiar un template a un fichero de la máquina remota"
      template: 
        src: template/index.j2
        dest: /var/www/html/index.html  
        owner: www-data
        group: www-data
        mode: '0644'

</pre>

hosts
<pre>

madandy@toyota-hilux:~/Documentos/SegundoASIR/github/taller_ansible_vagrant/Taller1$ cat hosts 
all:
  children:
    servidores:
      hosts:
        ansible:
          ansible_ssh_host: 192.168.1.157
          ansible_ssh_user: usuario
          ansible_ssh_private_key_file: /home/madandy/.ssh/id_rsa
          bd_name: madandy
          bd_user: madandy
          bd_pass: madandy


</pre>


template/index.j2

<pre>
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/taller_ansible_vagrant/Taller1$ cat template/index.j2 
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Prueba Ansible</title> 
</head>

<body>
  <h1>Gathering Facts</h1>
  <p>Este ordenador se llama: {{ ansible_hostname }}</p>
  <p>SO: {{ ansible_distribution }} {{ ansible_distribution_release }} </p>
  <h1>Variables declaradas por el usuario a nivel de grupo</h1>
  <p>Nombre de la bd: {{ bd_name }}</p>
  <p>Usuario de la bd: {{ bd_user }}</p>
  <h1>Variables declaradas por el usuario a nivel de nodo</h1>
  <p>IP: {{ ansible_ssh_host }}</p>
</body>
</html>

</pre>

h2. Entrega una captura de pantalla donde se vea que se ha finalizado la ejecución del playbook.

Como lo tengo en ssh, te lo pongo copiado:

<pre>
```
madandy@toyota-hilux:~/Documentos/SegundoASIR/github/taller_ansible_vagrant/Taller1$ ansible-playbook -i hosts site.yaml
 ____________
< PLAY [all] >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

 ________________________
< TASK [Gathering Facts] >
 ------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [ansible]
 ________________________________
< TASK [Actualizamos el sistema] >
 --------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [ansible]
 __________________________________
< TASK [Instalar paquetes con apt] >
 ----------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [ansible]
 ___________________________________________
< TASK [Copiar fichero a la máquina remota] >
 -------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [ansible]
 _____________________________________________________________
< TASK [Copiar un template a un fichero de la máquina remota] >
 -------------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

changed: [ansible]
 ____________
< PLAY RECAP >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ansible                    : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

</pre>

h2. Responde: ¿Cómo se llama la propiedad que permite que las tareas que ya se han realizado no se vuelvan a ejecutar?

<pre>

La propiedad se llama idempotencia, esto significa que, las tareas solo se ejecutan si algo ha cambiado.

</pre>

h2. Captura de pantalla, donde se vea el fichero foo.txt en el servidor configurado.

En el contenedor, vemso que se ha cambiado y creado el txt:

<pre>
usuario@ansible:~$ cat /etc/foo.txt
Prueba pruebita de Ansible, baby
usuario@ansible:~$ 

</pre>

h2. Captura de pantalla donde se vea el acceso desde el navegador al servidor web, y se vea el contenido del fichero index.html.

![alt text](image.png)

h2. Entrega la URL de tu repositorio con el que estás trabajando.

<pre>
https://github.com/madand1/taller_ansible_vagrant
</pre>