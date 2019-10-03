

# Docker-Gitea
Docker Image Gitea for Raspberry pi 3+/3/2

This image is the latest version of Gitea, Dockerfile get and download the last version.

As oficial Gitea this image exports:
- 3000 for webUI
- 22 for ssh.
- The repositoy and other data are located in /data

## Install
Command line:
```
docker run -d -p 3000:3000 -p 222:22 -v /your/path/for/data:/data mephistoxol/gitea
```

Docker Compose:
```
version: '3.2'
services:
  app:
    container_name: gitea_app
    image: mephistoxol/gitea
    restart: unless-stopped
    networks:      
      - internal-network
    ports:
      - "3000:3000"
      - "222:22"
    volumes:
      - ./data/app/data:/data
```

Ansible:
```
      docker_container:
        name: gitea_app
        image: mephistoxol/gitea
        volumes:
          - /your/path/for/data:/data
        ports:
          - 3000:3000
        restart_policy: unless-stopped
        # Traefik optional
        labels:
          traefik.frontend.rule: "Host:gitea.domain.com"
          traefik.port: "3000"
          traefik.frontend.redirect.entryPoint: "https"
        networks:
          - name: internal-network
      register: result
```

## Database
You can choose type of Database in the install web.

NOTE: If you want to use mysql db you need other container like ```linuxserver/mariadb``` and you must create a db and user with privileges from gitea_app container 
