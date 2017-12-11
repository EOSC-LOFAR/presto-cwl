FROM kernsuite/base:3
RUN docker-apt-install presto python-presto
ENV USER root
ENV HOME /root
RUN mkdir /code
WORKDIR /code
