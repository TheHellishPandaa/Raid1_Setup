# Raid1_Setup

Este script automatiza la configuración de un RAID 1 en Linux utilizando mdadm.

## Características

- Muestra los discos disponibles en el sistema.

- Permite al usuario seleccionar los discos para el RAID 1.

- Opción para formatear los discos antes de la configuración.

- Crea y configura el RAID 1.

- Formatea el RAID con el sistema de archivos ext4.

- Monta el RAID y lo agrega a /etc/fstab para montaje automático en el arranque.

- Guarda la configuración del RAID en mdadm.conf.

## Requisitos

- Linux con soporte para mdadm.

- Dos discos disponibles sin datos importantes.

- Privilegios de superusuario.

## Instalación

Clona este repositorio y accede a la carpeta:
````
git clone https://github.com/tu-usuario/raid1_setup
cd raid1_setup
````

## Uso

Ejecuta el script con permisos de superusuario:
````
sudo ./raid1_setup.sh
````
## Sigue las instrucciones en pantalla para configurar tu RAID 1.

## Notas

- Asegúrate de respaldar tus datos antes de ejecutar el script.

- No interrumpas el proceso una vez iniciado.

## Licencia

Este proyecto está bajo la licencia GNU (General Public License).

