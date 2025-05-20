FROM odoo:17

# Evita prompts interactivos al instalar paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instala las dependencias necesarias del sistema
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

# Copia requerimientos y módulos
COPY ./requirements.txt /requirements.txt
COPY ./addons /mnt/extra-addons

# Instala pip y las dependencias de Python
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /requirements.txt

# Expone el puerto Odoo
EXPOSE 8069

# Comando por defecto
CMD ["odoo", "-c", "/etc/odoo/odoo.conf"]
