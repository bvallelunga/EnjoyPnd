FROM node
MAINTAINER Brian Vallelunga <vallelungabrian@gmail.com>

RUN mkdir /enjoypnd
RUN mkdir /enjoypnd/logs
WORKDIR /enjoypnd
COPY . /enjoypnd/
RUN npm install -g forever coffee-script
RUN npm install

EXPOSE 1337
CMD ["coffee", "/enjoypnd/start.coffee"]
