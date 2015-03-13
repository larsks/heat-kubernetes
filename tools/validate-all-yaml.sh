#!/bin/sh

TOPLEVEL=$(git rev-parse --show-toplevel)
cd $TOPLEVEL

git ls-files |
	grep '\.yaml' |
	xargs python ${TOPLEVEL}/tools/validate-yaml.py -v || exit 1

