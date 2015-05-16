FROM ruby:2.2

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without development test

COPY . /usr/src/app

RUN apt-get update && \
	nodejs --no-install-recommends && \
	apt-get install -y imagemagick && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]