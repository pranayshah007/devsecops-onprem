#!/bin/bash

if which openvasmd; then 
    echo 'openvas already installed lets move ahead'
else
    add-apt-repository ppa:mrazavi/openvas -y
    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt install sqlite3 openvas9 libopenvas9-dev -y
    wget -q https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
    tar -zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
    mv arachni-1.5.1-0.5.12 /opt/arachni && \
    ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    rm -rf arachni*
    mkdir -p /var/run/redis && \
    wget -q --no-check-certificate \
    https://raw.githubusercontent.com/kurobeats/OpenVas-Management-Scripts/master/openvas-check-setup \
      -O /openvas-check-setup && \
    chmod +x /openvas-check-setup && \
    PUBLIC_HOSTNAME=localhost \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="-a 0.0.0.0 --client-watch-interval=0"/' /etc/init.d/openvas-manager && \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="--mlisten 0.0.0.0 -m 9390 --gnutls-priorities=SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"/' /etc/init.d/openvas-gsa && \
    sed -i 's/^\[ -n "$HTTP_STS_MAX_AGE" \]/a[ -n "$PUBLIC_HOSTNAME" ] && DAEMON_ARGS="$DAEMON_ARGS --allow-header-host=$PUBLIC_HOSTNAME"/' /etc/init.d/openvas-gsa && \
    sed -i 's/PORT_NUMBER=4000/PORT_NUMBER=4403/' /etc/default/openvas-gsa && \
    sed -i 's/#LISTEN_ADDRESS="0.0.0.0"/LISTEN_ADDRESS="0.0.0.0"/' /etc/default/openvas-gsa && \
    sed -i 's/#ALLOW_HEADER_HOST=/ALLOW_HEADER_HOST=192.168.34.4/' /etc/default/openvas-gsa
    # greenbone-nvt-sync --rsync > /dev/null
    # greenbone-scapdata-sync --rsync > /dev/null
    # greenbone-certdata-sync --rysnc > /dev/null
    # BUILD=true /start && \
    # service openvas-scanner stop && \
    # service openvas-manager stop && \
    # service openvas-gsa stop && \

    service redis-server stop
    systemctl enable openvas-scanner
    systemctl enable openvas-manager
    systemctl enable openvas-gsa

    # systemctl restart openvas-scanner
    # systemctl restart openvas-manager
    # systemctl restart openvas-gsa
fi
service redis-server restart
export COMMUNITY_NVT_RSYNC_FEED=rsync://feed.community.greenbone.net:/nvt-feed
greenbone-nvt-sync --rsync > /dev/null
export COMMUNITY_SCAP_RSYNC_FEED=rsync://feed.community.greenbone.net:/scap-data
greenbone-scapdata-sync --rsync > /dev/null
export COMMUNITY_CERT_RSYNC_FEED=rsync://feed.community.greenbone.net:/cert-data
greenbone-certdata-sync --rysnc > /dev/null
systemctl restart openvas-scanner
systemctl restart openvas-manager
systemctl restart openvas-gsa
openvasmd --rebuild --progress