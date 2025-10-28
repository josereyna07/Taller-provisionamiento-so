# Taller Vagrant + Provisionamiento con Shell

Objetivo
Aprender a crear y configurar máquinas virtuales con Vagrant, utilizando scripts en Shell para instalar servicios y desplegar una aplicación web básica conectada a una base de datos PostgreSQL.

Preparación del entorno
Primero se debe hacer un fork del repositorio base disponible en:
https://github.com/jmaquin0/vagrant-web-provisioning.git

Luego se clona el repositorio en la máquina local:
git clone https://github.com/tu-usuario/vagrant-web-provisioning.git

cd vagrant-web-provisioning

Es importante tener instalados Vagrant, VirtualBox y Git antes de continuar.

Configuración del Vagrantfile
El archivo Vagrantfile define dos máquinas virtuales:

web: que funcionará como servidor Apache y PHP.

db: que tendrá instalado PostgreSQL.

Cada máquina tiene su propia IP privada para que puedan comunicarse entre sí, por ejemplo:

web: 192.168.56.10

db: 192.168.56.11

También cada una se provisiona automáticamente con un script en Shell (provision-web.sh y provision-db.sh).

Provisionamiento de la máquina web
El script provision-web.sh instala Apache y PHP, y configura el servidor para servir los archivos desde /var/www/html.

Para levantar la máquina se ejecuta:
vagrant up web

Luego se puede abrir el navegador y visitar la dirección:
http://192.168.56.10

Ahí debería aparecer la página web creada en el archivo index.html.

Sitio web en HTML
Se debe crear un archivo llamado index.html con un mensaje sencillo, por ejemplo:

<!DOCTYPE html> <html> <head> <title>Bienvenido</title> </head> <body> <h1>¡Hola! Soy José Daniel Arango Reina</h1> <p>Esta es mi página servida con Apache y Vagrant.</p> </body> </html>

Este archivo se guarda en la carpeta compartida del proyecto para que se copie automáticamente al directorio /var/www/html de la máquina virtual.

Script en PHP
Se crea un archivo llamado info.php para probar que PHP funciona correctamente.
Por ejemplo:

<?php phpinfo(); ?>

Más adelante, este mismo archivo se modifica para conectarse con la base de datos PostgreSQL:

<?php $conn = pg_connect("host=192.168.56.11 dbname=ejemplo user=vagrant password=vagrant"); if (!$conn) { die("Error al conectar con la base de datos."); } $result = pg_query($conn, "SELECT * FROM personas"); if (!$result) { die("Error al ejecutar la consulta."); } echo "<h1>Conexión exitosa con la base de datos PostgreSQL 🎉</h1>"; echo "<table border='1'><tr><th>ID</th><th>Nombre</th></tr>"; while ($row = pg_fetch_assoc($result)) { echo "<tr><td>{$row['id']}</td><td>{$row['nombre']}</td></tr>"; } echo "</table>"; pg_close($conn); ?>

Este archivo se puede abrir desde el navegador con:
http://192.168.56.10/info.php

Provisionamiento de la máquina de base de datos
El script provision-db.sh instala PostgreSQL, crea un usuario, una base de datos llamada “ejemplo” y una tabla de ejemplo.

#!/bin/bash
echo "Instalando PostgreSQL..."
sudo apt update -y
sudo apt install -y postgresql postgresql-contrib

sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
sudo -u postgres psql -c "CREATE DATABASE ejemplo OWNER vagrant;"
sudo -u postgres psql -d ejemplo -c "
CREATE TABLE personas (
id SERIAL PRIMARY KEY,
nombre VARCHAR(100)
);
INSERT INTO personas (nombre) VALUES ('Ana'), ('Carlos'), ('Daniel');
"

Configuración para permitir conexiones externas

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = ''/g" /etc/postgresql//main/postgresql.conf
echo 'host all all 0.0.0.0/0 md5' | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql

Puesta en marcha
Para levantar ambas máquinas:
vagrant up

Con eso se instalarán automáticamente todos los servicios configurados en los scripts.

Para acceder a las máquinas manualmente:
vagrant ssh web
vagrant ssh db

Desde la máquina web se puede probar la conexión a la base de datos con:
psql -h 192.168.56.11 -U vagrant -d ejemplo

Resultado final
Al acceder desde el navegador a http://192.168.56.10
 se muestra la página HTML.
Al abrir http://192.168.56.10/info.php
 se visualizan los datos obtenidos desde la base de datos PostgreSQL en la tabla personas.

Esto demuestra que la conexión entre las dos máquinas funciona correctamente y que la aplicación web se despliega con éxito.

Conclusiones
Este taller permitió comprender cómo usar Vagrant para crear entornos virtuales automatizados mediante scripts en Shell.
También se practicó la instalación de un servidor web Apache con PHP y una base de datos PostgreSQL, además de la comunicación entre ambas máquinas virtuales.
El resultado es un entorno reproducible, fácil de configurar y funcional para el despliegue de aplicaciones web básicas.

Autor: José Daniel Arango Reina
Universidad Autónoma de Occidente
Ingeniería Informática