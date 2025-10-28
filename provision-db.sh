#!/usr/bin/env bash

# Actualizar paquetes
sudo apt-get update -y

# Instalar PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Habilitar y arrancar PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Crear usuario, base de datos y tabla
sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
sudo -u postgres psql -c "CREATE DATABASE ejemplo OWNER vagrant;"
sudo -u postgres psql -d ejemplo -c "CREATE TABLE personas(id SERIAL PRIMARY KEY, nombre VARCHAR(50));"
sudo -u postgres psql -d ejemplo -c "INSERT INTO personas(nombre) VALUES ('Ana'), ('Carlos'), ('Daniel');"
