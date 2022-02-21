#!/bin/sh

# Update password.
echo "root:$PASSWORD" | chpasswd

# Generate SSH key if not exist.
if [ ! -f "/etc/ssh/ssh_host_key" ]; then
	ssh-keygen -A
	ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key
fi

# Start SSH daemon
/usr/sbin/sshd

# Run additional script
if [ ! -z $SCRIPT ]; then
	chmod +x $SCRIPT
	$SCRIPT
fi

sleep infinity
