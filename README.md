# Sepia

[![Build Status](https://travis-ci.org/myfoot/sepia.png?branch=develop)](https://travis-ci.org/myfoot/sepia)

## System dependencies

- `Ruby` : 2.0
- `Rails` : 4.0.0
- `MySQL` : 5.6
- `Redis` : 2.6.14

## Configuration

### config/settings.yml

Please copy the `config/settings.yml.sample` to `config/settings.yml` .

```yaml
social:
  twitter:
    consumer_key: 'xxx'
    consumer_secret: 'xxx'
  facebook:
    consumer_key: 'xxx'
    consumer_secret: 'xxx'
  google:
    consumer_key: 'xxx'
    consumer_secret: 'xxx'
```

### config/database.yml

```yaml
development:
  adapter: mysql2
  database: sepia_dev
  pool: 5
  username: root
  password: password
  host: localhost
  encoding: utf8

test:
  adapter: sqlite3
  database: db/test.sqlite3
  pool: 5
  timeout: 5000

production:
  adapter: mysql2
  database: sepia
  pool: 5
  username: root
  password: password
  host: localhost
  encoding: utf8
```

## Database creation

```shell
$ rake db:migrate
```

## Database initialization

`nothing to do`

## How to run the test suite

```shell
$ rspec
```

## How to run the `Sepia` for development

### Start the redis

```shell
$ redis-server
```

### if you want to start with WEBrick

```shell
$ bundle exec rails s
```

### Start the sidekiq

```shell
$ bundle exec sidekiq
```

## How to deploy the `Sepia` for production

### create `config/settings.beta.yml`

copy `config/settings.yml.sample` to `config/settings.beta.yml`
and write the key/secret to `config/settings.beta.yml`.

### create `config/deploy.yml`

copy `config/deploy.yml.sample` to `config/deploy.yml`.

```yaml
user: someone
host:
  web:
    - test-web
  db:
    - test-db
  app:
    - test-app
  sidekiq:
    - test-sidekiq
```

### deploy via `capistrano`

at firsttime

```shell
$ bundle exec cap deploy:setup
$ bundle exec cap deploy:update_code
$ bundle exec cap db:init
$ bundle exec cap deploy:start
```

redeploy

```shell
$ bundle exec cap deploy
```
