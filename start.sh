#!/bin/bash

# Genera dinámicamente el archivo odoo.conf
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

# Ejecuta Odoo con el archivo recién generado
/usr/bin/odoo -c /etc/odoo/odoo.conf --http-port=${PORT} --xmlrpc-interface=0.0.0.0
