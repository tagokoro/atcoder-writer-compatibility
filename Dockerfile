FROM ruby:3.2.2

ENV RAILS_ENV=production

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev npm yarn

ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME
RUN bundle install

COPY . $APP_HOME

EXPOSE 3000