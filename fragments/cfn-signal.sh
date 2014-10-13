#!/bin/sh
#
# notify heat that configuration of this server is complete.

cfn-signal -e0 --data 'OK' -r 'Setup complete' '$WAIT_HANDLE'
