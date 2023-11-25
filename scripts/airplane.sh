#!/bin/sh

status () {
	status=$(connmanctl technologies | sed '4!d' | awk '{print $3}')
	if [ "$status" = "True" ]; then
		echo "off"
	else
		echo "on"
	fi
}

if [ "$1" = "status" ]; then
	status
fi

if [ "$1" = "toggle" ]; then
	stat=$(status)
	if [ $stat = "True" ]; then
		connmanctl enable wifi
	else
		connmanctl disable wifi
	fi
fi
