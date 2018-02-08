#!/bin/bash
set -e

if [[ "$1" == "thebestcoin-cli" || "$1" == "thebestcoin-tx" || "$1" == "thebestcoind" || "$1" == "test_thebestcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	if [[ ! -s "$BITCOIN_DATA/thebestcoin.conf" ]]; then
		cat <<-EOF > "$BITCOIN_DATA/thebestcoin.conf"
		addnode=5.230.11.232
		addnode=5.230.11.233
		printtoconsole=1
		rpcallowip=::/0
		rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
		rpcuser=${BITCOIN_RPC_USER:-bitcoin}
		EOF
		chown bitcoin:bitcoin "$BITCOIN_DATA/thebestcoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.thebestcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.thebestcoin

	exec gosu bitcoin "$@"
fi

exec "$@"
