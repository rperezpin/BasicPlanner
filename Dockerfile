FROM odoo:17

# Instala todas las dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev \
    build-essential \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
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
    && pip install ldap3 \
    && pip install python-ldap \
    && pip install --no-cache-dir -r /requirements.txt

# Expone el puerto Odoo
EXPOSE 8069

# Configuración por defecto de Odoo
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
