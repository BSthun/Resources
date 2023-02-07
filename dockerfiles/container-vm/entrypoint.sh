#!/bin/sh

# First startup setup
if [ ! -f "/etc/ssh/ssh_host_key" ]; then
	# Generate SSH key
	ssh-keygen -A
	ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key

	# Set password
	echo "root:$PASSWORD" | chpasswd
	
	# Run first startup script
	if [ ! -z $FIRST_SCRIPT ] && [ ! -f $FIRST_SCRIPT ]; then
		chmod +x $FIRST_SCRIPT
		$FIRST_SCRIPT
	fi

	# Set script permission
	if [ ! -z $SCRIPT ] && [ ! -f $SCRIPT ]; then
		chmod +x $SCRIPT
	fi
fi

# Start SSH daemon
/usr/sbin/sshd

# Run generic startup script
if [ ! -z $SCRIPT ]; then
	$SCRIPT
fi

# Keep container alive
sleep infinity
