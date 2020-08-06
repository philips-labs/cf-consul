FROM alpine:latest AS builder
ENV CONSUL_VERSION 1.8.0


WORKDIR /consul
RUN apk update \
 && apk add curl \
 && apk add gnupg \
 && apk add unzip 

# Download Vault and verify checksums (https://www.hashicorp.com/security.html)
COPY resources/hashicorp.asc /tmp/
COPY config /config
# Fix exec permissions issue that come up due to the way source controls deal with executable files.
RUN gpg --import /tmp/hashicorp.asc
RUN curl -Os https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
RUN curl -Os https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS
RUN curl -Os https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig

# Verify the signature file is untampered.
RUN gpg --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS
# The checksum file has all platforms, we are interested in only linux x64, so only check that one.
RUN grep -E '_linux_amd64' < consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c
RUN unzip consul_${CONSUL_VERSION}_linux_amd64.zip

FROM alpine:latest 
LABEL maintainer="Andy Lo-A-Foe <andy.lo-a-foe@philips.com>"
RUN apk update \
 && apk add jq \
 && apk add ca-certificates \
 && rm -rf /var/cache/apk/*

WORKDIR /app
COPY --from=builder /consul/consul /app
COPY --from=builder /config /app/config
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 8080
CMD ["/app/run.sh"]

