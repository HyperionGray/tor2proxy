# tor2proxy
Forwards requests via Tor, and then onwards to another proxy. The best way to use this is to
buy a proxy anonymously (e.g. via Bitcoin or Gift Card). This allows you to browse anonymously
while not appearing to come from Tor, making you more stealthy. It is not recommended that
you use this for strong anonymity, as your browser is not hardened like Tor Browser is. Following
this guide is, however, a good start: https://vikingvpn.com/cybersecurity-wiki/browser-security/guide-hardening-mozilla-firefox-for-privacy-and-security

In order to use this purchase an HTTP proxy and fill in the details in the squid.conf to include
your parent proxy information (the proxy you will be forwarding traffic to)

```
#####Enter your proxy information here
cache_peer <ip or domain name> parent <port> 0 no-query default login=<password>
#################
```

Install docker and then just run `bash build.sh`. Your tor2proxy docker image should now be built.
Find the image hash and run `start.sh image_hash`. You should then have
a working tor2proxy. By default tor2proxy protects the local http proxy daemon with the
credentials hyperion and IUW8292. An example request is below:

```
$ curl -u hyperion:IUW8292 -x http://localhost:8091 https://wtfismyip.com/text
```

# Bugs?

File an issue or hit me up on twitter @_hyp3ri0n

---

[![define hyperion gray](https://hyperiongray.s3.amazonaws.com/define-hg.svg)](https://hyperiongray.com/?pk_campaign=github&pk_kwd=tor2proxy "Hyperion Gray")
