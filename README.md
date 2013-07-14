# Sepia

## System dependencies

- `Ruby` : 2.0
- `Rails` : 4.0.0-rc
- `MySQL` : 5.6

## Configuration

### config/settings.yml

```yaml
social:
  twitter:
    consumer_key: 'xxx'
    consumer_secret: 'xxx'
  facebook:
    consumer_key: 'xxx'
    consumer_secret: 'xxx'
```

### config/database.yml

```yaml
development:
  adapter: mysql2
  database: sepia-dev
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
