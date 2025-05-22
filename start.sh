#!/bin/bash
set -e  # Detener en caso de error

echo ">>> Validando entorno..."
[ -z "$PGPORT" ] && echo "❌ PGPORT no está definida!" && env && exit 1

echo ">>> Generando odoo.conf con:"
echo "PGHOST=$PGHOST PGPORT=$PGPORT PGUSER=$PGUSER"

mkdir -p /var/log/odoo /var/lib/odoo /mnt/extra-addons /mnt/custom-addons
chown -R odoo:odoo /var/log/odoo /var/lib/odoo /mnt/extra-addons /mnt/custom-addons /tmp

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

echo ">>> Borrando caché de assets antiguos..."
find /var/lib/odoo -name "*.assets.json" -delete || true

echo ">>> Recompilando assets y actualizando módulos..."
su odoo -s /bin/bash -c "odoo -c /etc/odoo/odoo.conf -u all --stop-after-init --log-level=debug"

echo ">>> Iniciando Odoo..."
exec su odoo -s /bin/bash -c "odoo -c /etc/odoo/odoo.conf --http-port=${PORT:-8069} --xmlrpc-interface=0.0.0.0"
