#!/bin/bash
set -e

if [[ "$1" == "ensocoin-cli" || "$1" == "ensocoin-tx" || "$1" == "ensocoind" || "$1" == "test_ensocoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	if [[ ! -s "$BITCOIN_DATA/ensocoin.conf" ]]; then
		cat <<-EOF > "$BITCOIN_DATA/ensocoin.conf"
		addnode=178.88.115.118
    addnode=194.87.146.58
    printtoconsole=1
		rpcallowip=::/0
		rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
		rpcuser=${BITCOIN_RPC_USER:-bitcoin}
		EOF
		chown bitcoin:bitcoin "$BITCOIN_DATA/ensocoin.conf"
	fi

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.ensocoin
	chown -h bitcoin:bitcoin /home/bitcoin/.ensocoin

	exec gosu bitcoin "$@"
fi

exec "$@"
