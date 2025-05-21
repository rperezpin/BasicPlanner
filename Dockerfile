FROM odoo:17

ENV DEBIAN_FRONTEND=noninteractive

###############################################################################
# 1️⃣  Sistema
###############################################################################
USER root

# --allow-downgrades para resolver libpq y --no-install-recommends para aligerar
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpq5 \
        libpq-dev \
        gcc g++ python3-dev build-essential libsasl2-dev \
        libldap2-dev libssl-dev libxml2-dev libxslt-dev libjpeg-dev \
        zlib1g-dev libffi-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
        liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
        libx11-dev libegl1-mesa libopus0 python3-ldap && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


###############################################################################
# 2️⃣  Código y requirements
###############################################################################
COPY ./requirements.txt /requirements.txt
COPY ./addons /mnt/extra-addons
COPY ./odoo17.conf /etc/odoo/odoo.conf

# Permite a pip sobrescribir los paquetes instalados por APT
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN pip install --upgrade pip && \
    pip install --no-cache-dir --break-system-packages -r /requirements.txt

###############################################################################
# 3️⃣  Logs, puertos y arranque
###############################################################################
RUN mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo

EXPOSE 8069

COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
