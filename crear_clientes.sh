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
PLANTILLA="/var/lib/libvirt/images/alpine.qcow2"
DISCO_DIR="/var/lib/libvirt/images"

# Crear el nuevo volumen
NUEVO_DISCO="${DISCO_DIR}/${NOMBRE_MAQUINA}.qcow2"
qemu-img create -f qcow2 -b "$PLANTILLA" -F qcow2 "$NUEVO_DISCO" "$TAMANO_VOLUMEN"

# Redimensionar sistema de ficheros
virt-resize --expand /dev/sda1 "$PLANTILLA" "$NUEVO_DISCO"

# Inyectar clave SSH manualmente en Alpine
mkdir -p /mnt/alpine
guestmount -a "$NUEVO_DISCO" -i /mnt/alpine

# Copiar la clave SSH al sistema Alpine
mkdir -p /mnt/alpine/root/.ssh
cat /home/madandy/.ssh/andy.pub > /mnt/alpine/root/.ssh/authorized_keys
chmod 600 /mnt/alpine/root/.ssh/authorized_keys
chmod 700 /mnt/alpine/root/.ssh
chown -R root:root /mnt/alpine/root/.ssh

# Habilitar SSH en Alpine
echo "PermitRootLogin yes" >> /mnt/alpine/etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /mnt/alpine/etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /mnt/alpine/etc/ssh/sshd_config

# Configurar red (eth0 como interfaz de red en Alpine)
echo -e "auto eth0\niface eth0 inet dhcp" > /mnt/alpine/etc/network/interfaces

# Desmontar el disco
guestunmount /mnt/alpine

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
