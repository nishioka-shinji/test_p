FROM ruby:3.1.2-alpine3.16

RUN apk update && \
    apk add --no-cache \
        gcc \
        g++ \
        make \
        libxml2-dev \
        libxslt-dev \
        sqlite-dev \
        gcompat && \
    gem install bundler -v '2.3.14' && \
    gem update
WORKDIR /app