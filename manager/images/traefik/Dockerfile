FROM traefik:v2.4

USER root

RUN apt-get update && apt-get install curl -y
RUN curl -fsSL https://get.docker.com | sh
RUN groupmod -g 998 docker
RUN usermod  -aG docker traefik

USER traefik