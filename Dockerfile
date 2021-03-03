FROM ubuntu:18.04

COPY ./docker-root/ /

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        ca-certificates gnupg2 wget libfcgi-bin git && \
    apt clean && \
    echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main'> /etc/apt/sources.list.d/ondrej-ubuntu-php-bionic.list

# Install PHP
# libfcgi0ldbl provides cgi-fcgi, which we'll use to send FastCGI requests to php-fpm (to test it works, typically) without passing through nginx
# we're pinning php7.4-* packages to what is first installed so there's no surprise upgrade later when adding an extension,
# ubuntu provided php packages are forbidden
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew install \
        libfcgi0ldbl \
        php7.4-fpm \
        php7.4-cli \
        php7.4-curl \
        php7.4-mysql \
        php7.4-xml \
        php7.4-zip \
        php7.4-amqp librabbitmq4 \
        php7.4-mbstring \
        php7.4-pgsql \
        php7.4-apcu \
        php7.4-redis \
        less nano procps \
    && apt clean \
    && mkdir -p /var/log/php/www/log /run/php-pid /run/php-sock \
    && echo "Package: php7.4-common\nPin: version $(apt-cache show php7.4-common | grep Version | head -n1 | cut -d' ' -f2 | sed -E 's,(.*-)[0-9]?\+(ubuntu.*),\1\*\+\2,1')\nPin-Priority: 990\n\nPackage: php7.4-*\nPin: release *\nPin-Priority: 500\n\nPackage: php8.* php7.* php5.* php-*\nPin: release *\nPin-Priority: -1\n\nPackage: php*\nPin: release o=Ubuntu\nPin-Priority: -1" >/etc/apt/preferences.d/priority-php

# Install NewRelic Php Agent
# https://docs.newrelic.com/docs/agents/php-agent/installation/php-agent-installation-tar-file
# https://discuss.newrelic.com/t/relic-solution-php-agent-and-daemon-containers/84841
ARG NEWRELIC_VERSION=9.16.0.295
ADD ["https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz", "/tmp/newrelic-agent.tar.gz"]
RUN mkdir -p /tmp/newrelic \
    && tar zxpf /tmp/newrelic-agent.tar.gz -C /tmp/newrelic \
    && NR_INSTALL_USE_CP_NOT_LN=1 NR_INSTALL_SILENT=1 /tmp/newrelic/newrelic-php5-${NEWRELIC_VERSION}-linux/newrelic-install install \
    && rm -rf /tmp/newrelic /tmp/newrelic-agent.tar.gz

# To override NR config files
COPY ./docker-root/ /

RUN update-alternatives --install /usr/sbin/php-fpm php-fpm /usr/sbin/php-fpm7.4 1

WORKDIR /app
CMD ["/bin/bash"]
