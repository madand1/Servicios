# Práctica (1 / 2): Servidores Web, Base de Datos y DNS en nuestros escenario de OpenStack

## Servidor DNS

Vamos a instalar un servidor dns en nami que nos permita gestionar la resolución directa e inversa de nuestros nombres. Cada alumno va a poseer un servidor DNS con autoridad sobre un subdominio de nuestro dominio principal gonzalonazareno.org, que se llamará **andres.gonzalonazareno.org.**

- Instalar bind9 en nami:

`sudo apt install nami`

## Creación de las vistas

Para ello, vamos a crear vistas pero, ¿qué es una vista? Una vista es una forma de organizar las zonas de resolución en un servidor DNS. Una vista es una zona de resolución que se puede configurar de forma independiente. Por ejemplo, podemos tener una vista para la resolución de los nombres de las máquinas de la red interna y otra vista para la resolución de los nombres de las máquinas de la red externa.

De esta forma, podemos tener un servidor DNS que resuelva los nombres de las máquinas de la red interna y otro servidor DNS que resuelva los nombres de las máquinas de la red externa.

- En este caso en concreto voy a crear 5 vistas:
  - Una vista que sera la que tendra Luffy,  


