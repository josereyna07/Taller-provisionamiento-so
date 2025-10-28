#!/usr/bin/env bash

# Actualizar paquetes del sistema
sudo apt-get update -y

# Instalar Apache, PHP y el módulo para PostgreSQL
sudo apt-get install -y apache2 php libapache2-mod-php php-pgsql

# Habilitar y arrancar el servicio de Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Copiar los archivos del proyecto desde la carpeta compartida de Vagrant
# /vagrant/ apunta al mismo directorio donde está tu Vagrantfile
sudo cp -r /vagrant/www/* /var/www/html/

# Asignar permisos al usuario del servidor web
sudo chown -R www-data:www-data /var/www/html

# (Opcional) Reiniciar Apache para aplicar cualquier cambio
sudo systemctl restart apache2

echo "✅ Servidor web instalado y listo. Apache y PHP están corriendo."
