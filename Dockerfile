FROM odoo:17

ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && apt-get install -y --fix-broken && \
    apt-get install -y gcc g++ python3-dev build-essential libsasl2-dev \
    libldap2-dev libssl-dev libxml2-dev libxslt-dev libpq-dev libjpeg-dev \
    zlib1g-dev libffi-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
    libx11-dev libegl1-mesa libopus0 python3-ldap && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


COPY ./requirements.txt /requirements.txt
COPY ./addons /mnt/extra-addons
COPY ./odoo17.conf /etc/odoo/odoo.conf

RUN pip install --upgrade pip && pip install --no-cache-dir -r /requirements.txt
RUN mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo

EXPOSE 8069

COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

