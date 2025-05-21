#!/bin/bash

export PGHOST=${PGHOST}
export PGPORT=${PGPORT}
export PGUSER=${PGUSER}
export PGPASSWORD=${PGPASSWORD}
export PGDATABASE=${PGDATABASE}

/usr/bin/odoo -c /etc/odoo/odoo17.conf --http-port=$PORT --xmlrpc-interface=0.0.0.0
