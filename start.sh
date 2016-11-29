#!/bin/bash

docker run --privileged --restart always -v squid-data:/var/spool/squid3 -v `pwd`/tor2proxy/squid.conf:/etc/squid3/squid.conf -p "8091:3128" --dns "127.0.0.1" $1
