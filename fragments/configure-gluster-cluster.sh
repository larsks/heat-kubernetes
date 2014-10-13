#!/bin/sh

echo "adding gluster peers"
minion_addresses="$MINION_ADDRESSES"
for minion in ${minion_addresses//,/ }; do
	gluster peer probe $minion
done

