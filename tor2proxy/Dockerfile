FROM sameersbn/squid

# Add Tor apt sources
RUN echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list

# Add Tor GPG key
RUN gpg --keyserver keys.gnupg.net --recv 886DDD89
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

RUN apt-get update

# SSL support
RUN apt-get -y install openssl
RUN mkdir -p /etc/ssl
RUN cd tmp && \
    openssl req -x509 -newkey rsa:2048 \
                -keyout server.key -out server.crt \
                -days 365 -nodes -subj '/CN=tor2proxy' && \
    cp server.key server.crt /etc/ssl/ && \
    rm server.key server.crt

RUN apt-get -y install apache2-utils

# Install Tor as transparent proxy
RUN apt-get install -y tor deb.torproject.org-keyring
RUN { \
	echo "Log notice file /var/log/tor/notices.log"; \
	echo 'VirtualAddrNetworkIPv4 10.192.0.0/10'; \
	echo 'AutomapHostsOnResolve 1'; \
	echo 'TransPort 9040'; \
	echo 'DNSPort 53'; \
    } >>  /etc/tor/torrc 

# Install other dependencies 
RUN apt-get install -y iptables python-pip python2.7-dev curl

# Install python dependencies
ADD requirements.txt /requirements.txt 
RUN pip install -r /requirements.txt


# IPtables script
ADD iptables.sh /iptables.sh
RUN chmod +x /iptables.sh
RUN mkdir /etc/iptables


# Tor Status script
ADD tor_status.py /tor_status.py
RUN chmod +x /tor_status.py

# Set squid auth
#RUN sudo sh -c "echo -n 'hyperion:' >> /etc/squid3/passwords"
#RUN sudo sh -c "openssl passwd 14mt1T4n -apr1 >> /etc/squid3/passwords"
RUN htpasswd -c -b /etc/squid3/passwords hyperion IUW8292 

# Init container script
ADD container-init.sh /container-init.sh
RUN chmod +x /container-init.sh
ENTRYPOINT ["/container-init.sh"]
