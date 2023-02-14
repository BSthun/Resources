# Customize bashrc
echo "export PS1='\[\033[36m\]\h \[\033[1;32m\][ \w ]▶ \[\033[00m\]'"  >> ~/.bashrc
echo "bind '"\e[A": history-search-backward'"  >> ~/.bashrc



# Install essential packages
sudo apt-get update
sudo apt-get install htop nload iotop wget curl ca-certificates gnupg lsb-release

# Install Docker
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install Gotop
wget -O /tmp/gotop.deb https://github.com/cjbassi/gotop/releases/download/3.0.0/gotop_3.0.0_linux_amd64.deb
sudo dpkg -i /tmp/gotop.deb

# Setup aliases
alias l="ls -al"

# Setup functions
function de() {
	docker exec -it $1 /bin/bash
}

function dh() {
	if [ -z "$1" ]; then
		export DOCKER_HOST=unix:///var/run/docker.sock
		return
	fi

	export DOCKER_HOST=unix:///var/run/docker.$1.sock
}
