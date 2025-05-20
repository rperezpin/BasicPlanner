#!/usr/bin/env bash

# Instalar librerías necesarias del sistema
apt-get update && apt-get install -y \
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
  libopus0

# Instalar dependencias Python
pip install --upgrade pip
pip install -r requirements.txt
