#!/bin/bash

# This script ensures that a tansparent Tor proxy is running 
# and that requests are routed via the proxy. 

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# Output colors
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"
GREEN="\\033[1;32m"

log_info() {
  echo ""
  echo -e "$BLUE > $1 $NORMAL"
}

log_success() {
  echo ""
  echo -e "$GREEN > $1 $NORMAL"
}

log_error() {
  echo ""
  echo -e "$RED >>> ERROR - $1$NORMAL"
}

random_string() {
    # Generate a random string with $1 bytes of entropy. It is base64 encoded,
    # so the resulting string is longer than $1 characters. You should
    # probably make $1 a multiple of 3, otherwise the base64 string will be
    # padded with '=' at the end.
    head -c $1 /dev/urandom | base64
}


generate_tor_hash_password() {
  # Generate a hash password from $1.
  tor --hash-password $1 --quiet
}

wait_for_tor() {
  # Wait until tor circuits are established.
  python /tor_status.py 2> /dev/null
  result=$?
  while [ $result -ne 0 ]; do
      log_info "Waiting for tor..."
      python /tor_status.py 2> /dev/null
      result=$?
      sleep 1
  done
  log_success "Tor circuit established"
}

check_ip() {
  # Check that requests are routed via Tor
  # using https://check.torproject.org
  log_info "Checking IP address with wtfismyip...."
  curl -s -m 60 https://wtfismyip.com/text
}

check_tor_is_used() {
  # Check that requests are routed via Tor
  # using https://check.torproject.org
  log_info "Checking Tor...."
  curl -s -m 60 https://check.torproject.org | sed -n "/<h1/,/<\/h1>/p" | grep -iq "This browser is configured to use Tor"  2> /dev/null
  result=$?
  if [ $result -ne 0 ]; then
      log_error "Tor is not working!"
      exit 1
  else
      log_success "Tor is working!"
  fi
}


TOR_PASSWORD=$(random_string 12)
TOR_HASH_PASSWORD=$(generate_tor_hash_password $TOR_PASSWORD)

setup_tor_control() {
  echo "ControlPort 9051" >> /etc/tor/torrc
  echo "HashedControlPassword ${TOR_HASH_PASSWORD}" >> /etc/tor/torrc
  export TOR_PASSWORD=$TOR_PASSWORD
}

setup_tor_control

# Start Tor
service tor restart
wait_for_tor

# Config IP Tables
sh /iptables.sh

# Check IP
check_ip

# Check Tor is being used for outbound connections
check_tor_is_used

# Start Nginx 
log_info "Starting squid.."
/sbin/entrypoint.sh
