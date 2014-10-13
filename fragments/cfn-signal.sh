#!/bin/sh

cfn-signal -e0 --data 'OK' -r 'Setup complete' '$WAIT_HANDLE'
