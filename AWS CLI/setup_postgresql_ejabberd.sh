#Script para instalar postgresql para XMPP
#Jesus Alfonso Varela
#Version 1.0

#!/bin/bash

set -e  # Detener la ejecución en caso de error

# Variables de configuración
PG_VERSION="14"
DB_NAME="ejabberd_db"
DB_USER="ejabberd"
DB_PASS="EjabberdSecurePass123"

echo "🚀 Iniciando instalación de PostgreSQL..."

# Actualizar sistema e instalar PostgreSQL
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y postgresql-$PG_VERSION postgresql-contrib

# Habilitar PostgreSQL en el inicio y arrancarlo
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Configurar la base de datos de Ejabberd
sudo -u postgres psql <<EOF
CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';
CREATE DATABASE $DB_NAME OWNER $DB_USER;
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF

# Configurar acceso remoto
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
sudo sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/$PG_VERSION/main/postgresql.conf
echo "host    $DB_NAME    $DB_USER    0.0.0.0/0    md5" | sudo tee -a $PG_HBA

# Reiniciar PostgreSQL para aplicar cambios
sudo systemctl restart postgresql

echo "🎉 PostgreSQL configurado correctamente para Ejabberd 12.4."
