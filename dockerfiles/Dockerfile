FROM traefik:v2.4

RUN mkdir /data \
    && touch /data/acme.json \
    && chmod 600 /data/acme.json

COPY config /