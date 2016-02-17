FROM ruby:2.2.0 

MAINTAINER Zane McCaig

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
ENV ENCRYPT_PASSWORD=TripTopFlipFlapDoDadDiddlyooo

# expose our port
EXPOSE 3000

# Run the application
CMD RAILS_ENV=production bundle exec rails s -b 0.0.0.0
