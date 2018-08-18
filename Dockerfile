# vim:set ft=dockerfile:
FROM ubuntu:bionic

# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -d /var/lib/postgresql -g postgres --uid=999 postgres

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y software-properties-common locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

ENV PG_MAJOR 10

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update \
    && apt-get \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        install -y postgresql-common \
        sudo \
        libpq-dev \
        python3-pip \
        python2.7-dev \
        python3.6-dev \
        postgresql-$PG_MAJOR \
        postgresql-contrib-$PG_MAJOR \
    && pip3 install tox

COPY ./ /dist

CMD ["/dist/run_test.sh"]
