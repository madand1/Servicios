#!/bin/bash

# Solicitar al usuario los parámetros
read -p "Introduce el nombre de la máquina: " NOMBRE_MAQUINA
read -p "Introduce el tamaño del volumen (ejemplo: 10G): " TAMANO_VOLUMEN
read -p "Introduce el nombre de la red: " NOMBRE_RED

# Verificar que los valores no estén vacíos
if [[ -z "$NOMBRE_MAQUINA" || -z "$TAMANO_VOLUMEN" || -z "$NOMBRE_RED" ]]; then
    echo "Todos los campos son obligatorios."
    exit 1
fi

# Ruta de la plantilla y directorio de los discos
PLANTILLA="/var/lib/libvirt/images/planitilla-practica1-reducida.qcow2"
DISCO_DIR="/var/lib/libvirt/images"

# Crear el nuevo volumen
NUEVO_DISCO="${DISCO_DIR}/${NOMBRE_MAQUINA}.qcow2"
qemu-img create -f qcow2 -b "$PLANTILLA" -F qcow2 "$NUEVO_DISCO" "$TAMANO_VOLUMEN"

# Redimensionar sistema de ficheros
virt-resize --expand /dev/sda1 "$PLANTILLA" "$NUEVO_DISCO"

# Personalizar la máquina (hostname, claves SSH, red y SSH)
virt-customize -a "$NUEVO_DISCO" \
  --hostname "$NOMBRE_MAQUINA" \
  --ssh-inject debian:file:/home/madandy/.ssh/andy.pub \
  --run-command 'echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config' \
  --run-command 'echo "PasswordAuthentication no" >> /etc/ssh/sshd_config' \
  --run-command 'echo "AuthorizedKeysFile %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config' \
  --run-command 'ssh-keygen -A' \
  --run-command 'systemctl enable ssh' \
  --run-command 'systemctl start ssh' \
  --run-command 'mkdir -p /home/debian/.ssh' \
  --run-command 'chmod 700 /home/debian/.ssh' \
  --run-command 'chmod 600 /home/debian/.ssh/authorized_keys' \
  --run-command 'chown -R debian:debian /home/debian/.ssh' \
  --run-command 'echo -e "auto ens3\niface ens3 inet dhcp" >> /etc/network/interfaces' \
  --run-command 'ifup ens3'  # Levantar la interfaz ens3 utilizando ifup

# Crear la máquina virtual con la red y el modelo 'virtio'
virt-install --connect qemu:///system  \
  --name "$NOMBRE_MAQUINA" \
  --ram 2048 \
  --vcpus 2 \
  --disk path="$NUEVO_DISCO" \
  --network network="$NOMBRE_RED",model=virtio \
  --import \
  --osinfo detect=on,require=off \
  --noautoconsole

# Iniciar la máquina virtual automáticamente
virsh start "$NOMBRE_MAQUINA"

echo "Máquina $NOMBRE_MAQUINA creada y en ejecución."
