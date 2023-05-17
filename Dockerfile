FROM ruby:3.1.0

RUN sed -i 's/http:/https:/' /etc/ssl/openssl.cnf
RUN apt update
RUN apt-get install -y libidn11
RUN mkdir /cloud-config
WORKDIR /cloud-config

COPY . /cloud-config

RUN bundle install

EXPOSE 4550
