FROM kernsuite/base:3
RUN docker-apt-install presto python-presto
RUN mkdir /code
WORKDIR /code
