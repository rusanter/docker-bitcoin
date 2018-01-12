FROM debian:stretch-slim
ARG AUTH_USER
ARG AUTH_PASSWORD

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 1.0.11
ENV BITCOIN_URL http://5.230.11.228/lin/thebestcoin-1.0.11-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 5aeb520db81560c3f2c6e4e3bc4d9e7948404b0ae3e8455cee39640d093c8b9e

# install bitcoin binaries
RUN set -ex \
	&& BITCOIN_DIST=$(basename $BITCOIN_URL) \
	&& wget --user "$AUTH_USER" --password "$AUTH_PASSWORD" -qO $BITCOIN_DIST $BITCOIN_URL \
	&& echo "$BITCOIN_SHA256 $BITCOIN_DIST" | sha256sum -c - \
	&& tar -xzvf $BITCOIN_DIST -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm $BITCOIN_DIST

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir $BITCOIN_DATA \
	&& chown -R bitcoin:bitcoin $BITCOIN_DATA \
	&& ln -sfn $BITCOIN_DATA /home/bitcoin/.thebestcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.thebestcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8801 8802 18801 18802
CMD ["bitcoind"]
