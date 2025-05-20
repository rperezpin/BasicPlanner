#!/bin/bash
./odoo-bin -c /etc/odoo/odoo17.conf --http-port=$PORT --log-level=debug --xmlrpc-interface=0.0.0.0
