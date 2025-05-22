#!/bin/bash

set -e  # Detener en error

echo ">>> Generando archivo odoo.conf con:"
echo "PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER PGPASSWORD=$PGPASSWORD"

cat > /etc/odoo/odoo.conf <<EOF
[options]
admin_passwd = Agerpix12345
db_host = ${PGHOST}
db_port = ${PGPORT}
db_user = ${PGUSER}
db_password = ${PGPASSWORD}
addons_path = /mnt/extra-addons
logfile = /var/log/odoo/odoo17.log
EOF

echo ">>> Archivo generado:"
[ -z "$PGPORT" ] && echo "❌ PGPORT no está definida!" && env && exit 1

cat /etc/odoo/odoo.conf

exec odoo -c /etc/odoo/odoo.conf --http-port=${PORT:-8069} --xmlrpc-interface=0.0.0.0
