FROM garrettboast/lua
MAINTAINER garrett@garrettboast.com
ENV VERSION=0.9.12

ENV CONFIG_FLAGS=""
ENV PGP_KEY=32A9EDDE3609931EB98CEAC315907E8E7BDD6BFE

EXPOSE 5269
EXPOSE 5222

RUN apk add --no-cache curl \
		build-base \
		gnupg \
		libc-dev \
		libidn \
		libidn-dev \
		lua-dev \
		lua-expat \
		lua-sec \
		lua-filesystem \
		lua-socket \
		make \
		openssl \
		openssl-dev \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${PGP_KEY} \
	&& echo "${PGP_KEY}:4:" | gpg --import-ownertrust \
	&& curl -sSLO https://prosody.im/downloads/source/prosody-${VERSION}.tar.gz \
	&& curl -sSLO https://prosody.im/downloads/source/prosody-${VERSION}.tar.gz.asc \
	&& gpg --verify prosody-${VERSION}.tar.gz.asc \
	&& tar -xzf prosody-${VERSION}.tar.gz \
	&& cd prosody-${VERSION} && ./configure --prefix=/usr ${CONFIG_FLAGS} \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& cd / \
	&& apk del curl \
                build-base \
                gnupg \
                libc-dev \
                libidn-dev \
                lua-dev \
                make \
                openssl-dev \
	&& rm -rf ${RM_DIRS} /prosody-${VERSION}* /usr/share/man /tmp/* /var/cache/apk/* /root/.gnupg/* \
	&& adduser -S prosody && addgroup -S prosody \
	&& echo -e '\npidfile = "/var/run/prosody.pid" \n' >> /etc/prosody/prosody.cfg.lua \
	&& mkdir -p /var/run/prosody/ /var/lib/prosody /etc/prosody/modules \
	&& chown prosody:prosody /var/run/prosody/ /var/lib/prosody

COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua

VOLUME ["/var/lib/prosody", "/etc/prosody", "/usr/lib/prosody/modules"]

USER prosody

ENTRYPOINT [""]

CMD ["/usr/bin/prosody"]
