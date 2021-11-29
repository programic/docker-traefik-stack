#!/usr/bin/env bash

docker login
docker build -t programic/traefik:latest .
docker push programic/traefik:latest