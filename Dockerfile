FROM odoo:17

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev gcc g++ python3-dev build-essential libsasl2-dev \
    libldap2-dev libssl-dev libxml2-dev libxslt-dev libjpeg-dev \
    zlib1g-dev libffi-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
    libx11-dev libegl1-mesa libopus0 python3-ldap wget gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Archivos de código y requerimientos
COPY ./requirements.txt /requirements.txt
COPY ./addons /mnt/extra-addons
COPY ./custom-addons /mnt/custom-addons

# Permisos y entorno
RUN chown -R odoo:odoo /mnt/extra-addons /mnt/custom-addons /var/log/odoo /var/lib/odoo /tmp
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Pip
RUN pip install --upgrade pip && \
    pip install --no-cache-dir --break-system-packages --ignore-installed -r /requirements.txt

# Logs y start
RUN mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo

EXPOSE 8069
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
