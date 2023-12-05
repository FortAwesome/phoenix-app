FROM quay.io/fortawesome/elixir:1.15.7-otp26.1.2-rust1.74.0

ENV DEBIAN_FRONTEND noninteractive

# Update and install some software requirements
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  curl \
  build-essential \
  wget \
  git \
  make \
  postgresql \
  inotify-tools \
  xz-utils \
  unzip \
  screen \
  locales

# Install Node
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 20.10.0

# install Node.js with package
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -

RUN apt-get install -y nodejs

# install NPM version
ENV NPM_VERSION 10.2.4

RUN npm install -g npm@$NPM_VERSION

# install Hex
RUN mix local.hex --force

ENV PHOENIX_VERSION 1.7.10

# install the Phoenix Mix archive
RUN mix archive.install --force hex phx_new $PHOENIX_VERSION

RUN mix hex.info

# include Dockerize to help launching containers
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-linux-amd64-v0.7.0.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.7.0.tar.gz && rm dockerize-linux-amd64-v0.7.0.tar.gz

# include wait-for-it.sh
RUN curl -o /bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod a+x /bin/wait-for-it.sh