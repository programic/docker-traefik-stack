# Installation
1. Copy `docker-compose.example.yml` to `docker-compose.yml` and modify the content
2. Create the external Traefik network you have set up, e.g. `docker network create --driver=overlay web`
3. You can now deploy your stack `bash deploy-stack.sh`
4. Check if everything is working properly `docker service ls`

# Implementation example
The example below shows how you can add Traefik to your project.

```yaml
version: '3.8'
services:

  nginx:
    image: my-project/my-image:latest
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-project-http.rule=Host(`my-project.test`)"
      - "traefik.http.routers.my-project-http.entrypoints=web"
      - "traefik.http.routers.my-project-http.middlewares=to-https@file"
      - "traefik.http.routers.my-project.rule=Host(`my-project.test`)"
      - "traefik.http.routers.my-project.entrypoints=websecure"
      - "traefik.http.routers.my-project.middlewares=secure-headers@file"
      - "traefik.http.routers.my-project.tls.certresolver=letsencrypt"
    networks:
      - network
      - web

networks:
  network:
  web:
    external: true
```