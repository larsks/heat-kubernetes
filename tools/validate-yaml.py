#!/usr/bin/python

import sys
import argparse
import yaml
import logging


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument('--verbose', '-v',
                   action='store_const',
                   const='INFO',
                   dest='loglevel')
    p.add_argument('input', nargs='*')
    p.set_defaults(loglevel='WARN')
    return p.parse_args()


def main():
    args = parse_args()
    logging.basicConfig(level=args.loglevel)
    res = 0

    for filename in args.input:
        with open(filename) as fd:
            try:
                yaml.load(fd)
                logging.info('%s: passed', filename)
            except yaml.error.YAMLError as error:
                res = 1
                logging.error('%s: failed: %s',
                              filename, error)

    return res

if __name__ == '__main__':
    sys.exit(main())
