FROM node:16-alpine

MAINTAINER Norman Walsh <norm@saxonica.com>

RUN npm install -g npm@7.24.2

WORKDIR /node

ADD package-lock.json .
ADD package.json .
ADD server.js .

RUN npm install

CMD ["node", "server.js"]
