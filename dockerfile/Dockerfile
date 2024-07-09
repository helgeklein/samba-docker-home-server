FROM ubuntu:24.04 AS base

# Silent install
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y \
        acl \
        attr \
        samba \
        smbclient \
        krb5-config \
        krb5-user \
        libpam-krb5 \
        winbind \
        libnss-winbind \
        libpam-winbind \
        python3-setproctitle \
        ldb-tools \
        tini \
        supervisor \
        inetutils-ping \
        dnsutils \
        iproute2 \
        nano \
        && rm -rf /var/lib/apt/lists/*

# Remove the default smb.conf
RUN rm /etc/samba/smb.conf

# Helper files
RUN  mkdir -p /usr/helpers
COPY --chmod=755 vars.sh /usr/helpers/vars.sh

#
# Target stage for DCs
#
FROM base AS dc

COPY --chmod=755 init-dc.sh /usr/helpers/init-dc.sh
COPY --chmod=755 samba-provision.sh /usr/helpers/samba-provision.sh

# Start Samba via Tini and our init script
ENTRYPOINT ["/bin/tini", "--", "/usr/helpers/init-dc.sh"]

#
# Target stage for FSs
#
FROM base AS fs

COPY --chmod=755 init-fs.sh /usr/helpers/init-fs.sh
COPY --chmod=755 samba-join.sh /usr/helpers/samba-join.sh

# Start Samba via Tini and our init script
ENTRYPOINT ["/bin/tini", "--", "/usr/helpers/init-fs.sh"]
