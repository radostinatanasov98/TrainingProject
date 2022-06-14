FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y nodejs \
    libxml2-dev \
    libxslt-dev \
    yarn \
    libffi-dev \
    libc-dev \
    file \
    imagemagick \
    git \
    tzdata \
    default-libmysqlclient-dev \
    ruby-full \
    mariadb-server

RUN gem install rails bundler
RUN gem install rails
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

ADD . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3030

CMD ["rails", "server", "-b", "0.0.0.0"]