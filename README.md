# tor2proxy
Forwards requests via Tor, and then onwards to another proxy. The best way to use this is to
buy a proxy anonymously (e.g. via Bitcoin or Gift Card). This allows you to browse anonymously
while not appearing to come from Tor, making you more stealthy. It is not recommended that
you use this for strong anonymity, as your browser is not hardened like Tor Browser is. Following
this guide is, however, a good start: https://vikingvpn.com/cybersecurity-wiki/browser-security/guide-hardening-mozilla-firefox-for-privacy-and-security

In order to use this purchase an HTTP proxy and fill in the details in the squid.conf to include
your proxy information:

```
#####Enter your proxy information here
cache_peer <ip or domain name> parent <port> 0 no-query default login=<password>
#################
```

```
$ curl -u username:password -x http://localhost:8091 https://wtfismyip.com/text
```

# Building

To build this just run build.sh when on the rebuild branch . Then to start the
container run start.sh with the image name as the first arg. Make sure to set
the proxy information to whatever you need it to be.