FROM ruby:2.2

ENV RAILS_ENV production

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without development test

COPY . /usr/src/app

RUN apt-get update && apt-get install -y nodejs imagemagick && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["rails", "server", "-b", "0.0.0.0"]