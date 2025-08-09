# Modern Samba Active Directory & File Server Docker Container Environment for Home Servers and Small Businesses

There aren't many configurations for running a Samba Active Directory domain controller and a Samba file server in Docker containers. Those that I could find had so many issues that I decided to build my own configuration from scratch.

## Features

- **Modern & secure** configuration based on Samba v4.
- Easily **upgradable** to a new base OS and new Samba versions.
- Bullet-proof **networking** with support for:
  - Forwarding of the AD DNS zone from the main DNS server to the Samba DC.
  - Forwarding from the Samba DC to the main DNS server.
  - Dynamic DNS updates of domain members.
  - Static external IP address (required for domain controllers).
  - Communication between container and host (normally isolated).
- Separate containers for the AD domain controller and the file server as recommended by the Samba Wiki.
- Samba Active Directory can be used as the **central user authentication system** by IAM tools like Authelia for single sign-on (SSO).
- AD domain **provisioning** and member **join scripts**.
- All data is stored outside the containers in bind-mounted Docker volumes so that the containers can be re-built at any time.
- The file server container supports:
  - POSIX ACLs.
  - Windows permissions/ACLs.
    - If used with an unprivileged Docker container, the option `acl_xattr:security_acl_name = user.NTACL` must be set on shares ([docs](https://www.samba.org/samba/docs/current/man-html/vfs_acl_xattr.8.html)).
    - Windows ACLs require the following settings in `smb.conf`:
      - `vfs objects = acl_xattr`
      - `acl_xattr:ignore system acls = yes`
      - `map acl inherit = yes`
  - Access-based enumeration (ABE).
  - Samba recycle bin.

## Documentation

Please see my [series of blog posts](https://helgeklein.com/blog/samba-active-directory-in-a-docker-container-installation-guide/) for instructions. The articles explain all aspects of the configuration in detail.-