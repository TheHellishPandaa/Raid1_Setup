#!/bin/bash

# Función para mostrar mensajes resaltados
function print_info() {
    echo -e "\e[1;34m$1\e[0m"
}
function print_warning() {
    echo -e "\e[1;33m$1\e[0m"
}
function print_error() {
    echo -e "\e[1;31m$1\e[0m"
}

# Mostrar los discos disponibles
print_info "Listado de discos disponibles:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

echo "\nIngrese el primer disco para RAID 1 (ejemplo: /dev/sdX):"
read DISK1
echo "Ingrese el segundo disco para RAID 1 (ejemplo: /dev/sdY):"
read DISK2
RAID_DEVICE=/dev/md0

# Verificar si los discos existen
if [ ! -b "$DISK1" ] || [ ! -b "$DISK2" ]; then
    print_error "Error: Uno o ambos discos no existen."
    exit 1
fi

# Preguntar si desea formatear los discos
print_warning "¿Desea formatear los discos antes de configurar el RAID? (s/n)"
read FORMAT_DISKS
if [ "$FORMAT_DISKS" == "s" ]; then
    print_info "Iniciando cfdisk para $DISK1"
    sudo cfdisk $DISK1
    print_info "Iniciando cfdisk para $DISK2"
    sudo cfdisk $DISK2
fi

# Instalar mdadm si no está instalado
if ! command -v mdadm &> /dev/null; then
    print_info "Instalando mdadm..."
    sudo apt update && sudo apt install -y mdadm
fi

# Crear el RAID 1
print_info "Creando RAID 1 en $RAID_DEVICE con $DISK1 y $DISK2"
sudo mdadm --create --verbose $RAID_DEVICE --level=1 --raid-devices=2 $DISK1 $DISK2

# Esperar a que se inicialice el RAID
print_info "Esperando a que se configure el RAID..."
sleep 5

# Verificar el estado del RAID
print_info "Estado del RAID:"
sudo mdadm --detail $RAID_DEVICE

# Crear el sistema de archivos
print_info "Formateando $RAID_DEVICE con ext4"
sudo mkfs.ext4 $RAID_DEVICE

# Crear un punto de montaje y montar el RAID
MOUNT_POINT=/mnt/raid1
print_info "Montando $RAID_DEVICE en $MOUNT_POINT"
sudo mkdir -p $MOUNT_POINT
sudo mount $RAID_DEVICE $MOUNT_POINT

# Agregar a fstab para montar en el arranque
print_info "Agregando configuración a /etc/fstab"
echo "$RAID_DEVICE $MOUNT_POINT ext4 defaults,nofail,discard 0 0" | sudo tee -a /etc/fstab

# Guardar la configuración del RAID
print_info "Guardando la configuración del RAID en mdadm.conf"
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

print_info "\nConfiguración del RAID 1 completada con éxito."
