FROM alpine

ARG VERSION=1.13.0

RUN apk --no-cache add coreutils && \
    mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    wget -q -O- https://github.com/digitalocean/doctl/releases/download/v${VERSION}/doctl-${VERSION}-linux-amd64.tar.gz | tar xzf - && \
    mv doctl /usr/local/bin/

COPY snapshot.sh /etc/periodic/15min/snapshot

CMD ["/usr/sbin/crond", "-f", "-d6"]
