FROM ubuntu:24.04

# Silent install
ARG DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update; \
    apt-get install -y \
        samba \
        smbclient \
        krb5-user \
        winbind \
        tini \
        nano;

# Remove the default smb.conf
RUN rm /etc/samba/smb.conf

# Helper files
RUN  mkdir -p /usr/helpers
COPY --chmod=755 init.sh /usr/helpers/init.sh
COPY --chmod=755 vars.sh /usr/helpers/vars.sh

# Cleanup
RUN apt-get purge --auto-remove -y && \
    rm -rf /var/lib/apt/lists/*

# Start Samba via Tini and our init script
ENTRYPOINT ["/bin/tini", "--", "/usr/helpers/init.sh"]
