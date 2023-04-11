# Scripts to create and start secondary docker engines
# Created by Bhumjate S. (BSthun)

#!/bin/bash

# Check <name>, <no> is provided
if [ -z "$1" || -z "$2" ]; then
	echo "Providing <name> and <no> is required"
	exit 1
fi

# Check <no> is a number
if ! [[ "$2" =~ ^[0-9]+$ ]]; then
	echo "<no> must be a number"
	exit 1
fi

# Define variables
export DBASE=/var/sec/engine.$1
export IFACE=enp3s0
export PORT_START=$((6000+($2*100)))
export PORT_END=$((6099+($2*100)))
export BINDING_ADDRESS=172.20.10.$(($2+2))

function setup_iptables() {
	export RULE="PREROUTING -i $IFACE -p tcp --match multiport --dports $PORT_START:$PORT_END -j DNAT --to-destination $BINDING_ADDRESS:$PORT_START-$PORT_END"
	iptables -t nat -C $RULE || iptables -t nat -A $RULE
}

# Check $DBASE.data exists
if [ ! -d "$DBASE.data" ]; then
	(
		# Wait for docker daemon to start
		while [ ! -S "$DBASE.sock" ]; do
			sleep 1
		done

		# Create docker network
		export DOCKER_HOST=unix://$DBASE.sock
		docker network create \
			--driver=bridge \
			--subnet=172.19.$2.0/24 \
			--gateway=172.19.$2.1 \
			--ip-range=172.19.$2.0/24 \
			--opt com.docker.network.bridge.name=docker1.$1 \
			--opt com.docker.network.bridge.enable_icc=true \
			--opt com.docker.network.bridge.host_binding_ipv4=$BINDING_ADDRESS \
			br0
		setup_iptables
	) &
else
	setup_iptables
fi

# Start docker daemon
dockerd --bridge=docker0 --data-root=$DBASE.data --exec-root=$DBASE.exec --host=unix://$DBASE.sock --pidfile=$DBASE.pid --ip 172.20.9.1
