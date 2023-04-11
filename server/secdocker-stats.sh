# Scripts to output docker stats for all secondary docker engines
# Created by Bhumjate S. (BSthun)
# Summary logic modified from https://stackoverflow.com/q/47331106/8022589

#!/bin/bash
IFS=;

# Output main docker engine stats in colored hilight
echo -e "[\e[1;96m/var/run/docker.sock\e[0m]";
STATS=`DOCKER_HOST=unix:///var/run/docker.sock docker stats --no-stream`

MEM=`echo $STATS | tail -n +2 | sed "s/%//g" | awk '{s+=$4} END {print s}'`
CPU=`echo $STATS | tail -n +2 | sed "s/%//g" | awk '{s+=$3} END {print s}'`
if [ -z "$MEM" ]; then
	MEM=0
fi
if [ -z "$CPU" ]; then
	CPU=0
fi

echo -e "Total Memory: \e[1;93m$MEM MiB\e[0m, Total CPU: \e[1;93m$CPU%\e[0m"
echo $STATS

# Output all secondary docker engines stats
for sock in /var/sec/engine.*.sock
do
	echo -e "[\e[1;96m$sock\e[0m]";
	STATS=`DOCKER_HOST=unix://$sock docker stats --no-stream`
	MEM=`echo $STATS | tail -n +2 | sed "s/%//g" | awk '{s+=$4} END {print s}'`
	CPU=`echo $STATS | tail -n +2 | sed "s/%//g" | awk '{s+=$3} END {print s}'`
	if [ -z "$MEM" ]; then
		MEM=0
	fi
	if [ -z "$CPU" ]; then
		CPU=0
	fi
	echo -e "Total Memory: \e[1;93m$MEM MiB\e[0m, Total CPU: \e[1;93m$CPU%\e[0m"
	echo $STATS
done
