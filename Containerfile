FROM docker.io/ruby:3.4-slim

RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libssl-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
    
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

RUN ruby db.rb

ENV RACK_ENV=production

CMD ["bundle", "exec", "falcon", "serve", "--bind", "http://0.0.0.0:3000"]