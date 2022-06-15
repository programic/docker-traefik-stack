# Installation
1. Copy `docker-compose.example.yml` to `docker-compose.yml` and modify the content
2. Create the external Traefik network you have set up, e.g. `docker network create --driver=overlay web`
3. Optional if dnsChallenge with TransIP
   1. Generate a Key Pair in the TransIP panel
   2. Save it as `transip.key` on the Docker Swarm server and in your password manager
   3. Create a secret `docker secret create transip-private-key ./transip.key`
   4. Remove `rm transip.key` on the Docker Swarm server
4. Create a acme.json file `cd data && touch acme.json && chmod 600 acme.json`
5. You can now deploy your stack `bash deploy-stack.sh`
6. Check if everything is working properly `docker service ls`

# Implementation example
The example below shows how you can add Traefik to your project.

```yaml
version: '3.8'
services:

  nginx:
    image: my-project/my-image:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      labels:
        - "traefik.enable=true"
        - "traefik.http.services.my-project.loadbalancer.server.port=80"
        - "traefik.http.routers.my-project-http.rule=Host(`my-project.test`)"
        - "traefik.http.routers.my-project-http.entrypoints=web"
        - "traefik.http.routers.my-project-http.middlewares=to-https@file"
        - "traefik.http.routers.my-project.service=my-project"
        - "traefik.http.routers.my-project.rule=Host(`my-project.test`)"
        - "traefik.http.routers.my-project.entrypoints=websecure"
        - "traefik.http.routers.my-project.middlewares=secure-headers@file"
        
        # Option 1: tlsChallenge
        - "traefik.http.routers.my-project.tls.certresolver=lets-encrypt"
          
        # Option 2: dnsChallenge with TransIP and a wildcard certificate
        - "traefik.http.routers.my-project.tls.certresolver=transip"
        - "traefik.http.routers.my-project.tls.domains[0].main=my-project.test"
        - "traefik.http.routers.my-project.tls.domains[0].sans=*.my-project.test"
    networks:
      - network
      - web

networks:
  network:
  web:
    external: true
```