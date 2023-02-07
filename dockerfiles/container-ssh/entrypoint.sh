#!/bin/sh

# First-time setup
if [ ! -f "/etc/ssh/ssh_host_key" ]; then
	# Generate SSH key
	ssh-keygen -A
	ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key

	# Set password
	echo "root:$PASSWORD" | chpasswd
	
	# Run one-time setup script
	if [ ! -z $SETUP_SCRIPT ] && [ -f $SETUP_SCRIPT ]; then
		chmod +x $SETUP_SCRIPT
		$SETUP_SCRIPT
	fi

	# Set startup script permission
	if [ ! -z $STARTUP_SCRIPT ] && [ -f $STARTUP_SCRIPT ]; then
		chmod +x $STARTUP_SCRIPT
	fi
fi

# Start SSH daemon
/usr/sbin/sshd

# Run startup script
if [ ! -z $STARTUP_SCRIPT ]; then
	$STARTUP_SCRIPT
fi

# Keep container alive
sleep infinity
