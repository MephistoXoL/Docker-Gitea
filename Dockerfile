FROM alpine

MAINTAINER XoL <MephistoXoL@gmail.com>

EXPOSE 22 3000

ENV USER git
ENV GITEA_CUSTOM /data/gitea

## INSTALL PACKAGES
RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata \
    jq

## GET VERSION, URL AND INSTALL
RUN VERSION=$(curl -sX GET https://api.github.com/repos/go-gitea/gitea/releases | jq -r 'first(.[]) | .tag_name' | sed 's/^.//') && \
    URL=$(curl -s https://api.github.com/repos/go-gitea/gitea/releases/tags/v$VERSION | jq -r '.assets[].browser_download_url' | grep arm-6 | awk 'NR==1{print $1}') && \
    mkdir -p /app/gitea && \
    curl -SLo /app/gitea/gitea $URL && \
    curl -SL https://github.com/go-gitea/gitea/archive/v$VERSION.tar.gz | tar xz gitea-$VERSION/docker --exclude=gitea-$VERSION/docker/Makefile --strip-components=3 && \
    chmod 0755 /app/gitea/gitea

## ADD USER AND GROUP GIT
RUN addgroup \
    -S -g 1001 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1001 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]

CMD ["/bin/s6-svscan", "/etc/s6"]