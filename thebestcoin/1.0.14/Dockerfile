FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 1.0.14
ENV BITCOIN_URL https://github.com/thebestcoin/thebestcoin/releases/download/v1.0.14/thebestcoin-1.0.14-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 caa5963130cc6e106aece678d6dbd52c08f4aa3c461dec20a0d65b8dc1c9d8e2

# install bitcoin binaries
RUN set -ex \
	&& BITCOIN_DIST=$(basename $BITCOIN_URL) \
	&& wget -qO $BITCOIN_DIST $BITCOIN_URL \
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
