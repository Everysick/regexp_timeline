FROM ruby:2.3
MAINTAINER everysick

ADD regexp_timeline /app/regexp_timeline

WORKDIR /app/regexp_timeline

RUN gem install bundler
RUN bundle install

CMD ["foreman", "start"]
