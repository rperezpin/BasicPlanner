#!/bin/bash

set -e  # Detener en caso de error

echo ">>> Generando archivo odoo.conf con:"
echo "PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGPASSWORD=$PGPASSWORD"

# Validar que PGPORT esté definida
[ -z "$PGPORT" ] && echo "❌ PGPORT no está definida!" && env && exit 1

# Crear archivo de configuración
cat > /etc/odoo/odoo.conf <<EOF
[options]
admin_passwd = Agerpix12345
db_host = ${PGHOST}
db_port = ${PGPORT}
db_user = odoo_user
db_password = Agerpix12345
addons_path = /mnt/extra-addons,/mnt/custom-addons
logfile = /var/log/odoo/odoo17.log
EOF

echo ">>> Archivo generado:"
cat /etc/odoo/odoo.conf

echo ">>> Actualizando todos los módulos para recompilar assets..."
odoo -c /etc/odoo/odoo.conf -u all --stop-after-init --log-level=debug
find /var/lib/odoo -name "*.assets.json" -delete

echo ">>> Iniciando Odoo..."
exec odoo -c /etc/odoo/odoo.conf --http-port=${PORT:-8069} --xmlrpc-interface=0.0.0.0
