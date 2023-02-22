FROM docker:20.10.1
RUN apk add --no-cache --upgrade bash jq curl
#COPY ./passwd /etc/passwd
#COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENV DOCKER_VERSION=20.10.1
ENV DOCKER_TLS_CERTDIR=/certs
ENTRYPOINT ["/bin/bash"]
#CMD ["bash"]