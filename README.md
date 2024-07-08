# Samba Docker Active Directory & File Server Containers for Home Server

There aren't many configurations for running a Samba Active Directory domain controller and a Samba file server in Docker containers. Those that I could find so many issues that I decided to build my own configuration from scratch.

## Features

- **Modern & secure** configuration based on Samba v4.
- Easily **upgradable** to a new base OS and to new Samba versions.
- Bullet-proof **networking** with support for:
  - Forwarding of the AD DNS zone from main DNS to the Samba DC.
  - Forwarding from the Samba DC to the main DNS server.
  - Dynamic DNS updates of domain members.
  - Static external IP address (required for domain controllers).
  - Communication between container and host (normally isolated).
- Separate containers for the AD domain controller and the file server as recommended by the Samba Wiki.
- Samba Active Directory can be used as the **central user authentication system** by IAM tools like Authelia for single sign-on (SSO).
- AD domain **provisioning** and member **join scripts**.
- All data is stored outside the containers in bind-mounted Docker volumes so that the containers can be re-built any time.
- The file server container supports:
  - Windows permissions (ACLs).
  - Access-based enumeration (ABE).
  - Samba recycle bin.

## Documentation

Please see my [series of blog posts](https://helgeklein.com/blog/samba-active-directory-in-a-docker-container-installation-guide/) for instructions. The articles explain all aspects of the configuration in detail.