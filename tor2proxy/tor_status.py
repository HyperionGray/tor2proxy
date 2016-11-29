#!/usr/env/python
import os
import sys
from stem.connection import PasswordAuthFailed
from stem.control import Controller

if __name__ == '__main__':

    with Controller.from_port(port=9051) as controller:

        try:
            controller.authenticate(password=os.environ['TOR_PASSWORD'])
        except PasswordAuthFailed:
            print("Unable to authenticate, password is incorrect")
            sys.exit(1)

        circuit_established = controller.get_info('status/circuit-established')

        if circuit_established == '1':
            print('Tor circuit established')
            sys.exit(0)
        else:
            print('Tor circuit not established')
            sys.exit(1)
