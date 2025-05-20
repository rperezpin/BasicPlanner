# Usa la imagen oficial de Odoo 17 como base
FROM odoo:17

# Instala dependencias del sistema necesarias para python-ldap y otras
RUN apt-get update && apt-get install -y \
    gcc \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    build-essential \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libffi-dev \
    libtiff5-dev \
    libjpeg8-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    libx11-dev \
    libegl1-mesa \
    libopus0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia tus módulos y requerimientos al contenedor
COPY ./requirements.txt /requirements.txt
COPY ./addons /mnt/extra-addons

# Instala dependencias Python
RUN pip install --upgrade pip \
    && pip install -r /requirements.txt

# Expone el puerto Odoo
EXPOSE 8069

# Configuración por defecto de Odoo
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
