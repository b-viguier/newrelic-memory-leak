FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
        less nano procps \
        libfcgi0ldbl

RUN echo "[www]\nlisten=/run/php-fpm.sock" > /usr/local/etc/php-fpm.d/zzz-newrelic-test.conf


ARG NEWRELIC_VERSION=9.16.0.295
ADD ["https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz", "/tmp/newrelic-agent.tar.gz"]
RUN mkdir -p /tmp/newrelic \
    && tar zxpf /tmp/newrelic-agent.tar.gz -C /tmp/newrelic \
    && NR_INSTALL_USE_CP_NOT_LN=1 NR_INSTALL_SILENT=1 /tmp/newrelic/newrelic-php5-${NEWRELIC_VERSION}-linux/newrelic-install install \
    && rm -rf /tmp/newrelic /tmp/newrelic-agent.tar.gz

WORKDIR /app

CMD ["/bin/bash"]
