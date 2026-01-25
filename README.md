# Roda on Falcon with DataStar Server-Sent Event Framework

This is a working demo to get you started with DataStar on Ruby/Roda.

Here's the documentation to the projects, that drive this demo/template/repo:

| Component | Project                                                       |
| --------- | ------------------------------------------------------------- |
| Webserver | [Falcon](https://github.com/socketry/falcon)                  |
| Backend   | [Roda](https://roda.jeremyevans.com)                          |
| Frontend  | HTML/ERB with [Data-Star](https://github.com/socketry/falcon) |

I love Roda for being lightweight, super-capable and expressiveness.\
For the webserver, I picked Falcon, because each request is executed within a
lightweight fiber and can block on up-stream requests without stalling the
entire server process.\
To me, a frontend cannot be simple enought (why I lean towards HTMx 💓 whenever
possible) - yet, when I first heard of Data-Star, my heart skipped a beat.

## Data-Star

> Datastar is a lightweight framework for building everything from simple sites
> to real-time collaborative web apps.

Data-Star aims to help you build backend-driven web applications that are
reactive and real-time by default.\
It leverages Server-Sent Events (SSE) to push updates from the server to the
client, enabling dynamic and interactive user experiences without the need for
complex frontend frameworks.

Video-Tutorial: [Build a Todo App with Data-Star and Python](https://www.youtube.com/watch?v=eA6PW-_Qh20).

See [views/datastar.erb](views/datastar.erb) for a simple example of Data-Star
usage.

It showcases:

- a `data-on` click listener that triggers `message` events from the server and
  updates the content of the matching `<div>` (identified by its `id`) whenever
  a new message is received.
- a simple form that implements the `Counter` example, every Frontend-Framework
  seems to have as their FizzBuzz demo.
- a `Countdown` example that updates the content of a `<div>` every second until
  it reaches zero.
- a simple `Item` list that is updated whenever a new item is added to the
  database.

## Run instructions

### Quick start

Install dependencies and start the app (defaults to port 3000):

```bash
bundle install
# start with the default Rack handler (uses config.ru)
bundle exec rackup -p 3000
# or explicitly use Falcon as the server
bundle exec rackup -s falcon -p 3000
# development mode (auto-reloads and reinitializes dev DB)
RACK_ENV=development bundle exec rackup -p 3000
```

Open http://localhost:3000/datastar in your browser.

### Endpoints (quick reference)

- `GET /datastar` — UI (see `views/datastar.erb`)
- `GET /hal-status` — HAL status fragment (see `views/hal-status.erb`)
- `POST /counter` — increment counter (see `app.rb`)
- `POST /counter/reset` — reset counter after delay (see `app.rb`)
- `GET /countdown-sse` — SSE countdown that patches `#countdown` (see `app.rb`)
- `POST /items` — add an item; patches the items partial (see
  `views/_items.erb`)

### Database setup

This demo uses Extralite (an embedded SQLite-like engine) and stores data in
`app.db` in the project root.

- In development the database is (re)initialized by `DevDB` when the app starts.
  To run with a fresh DB, set `RACK_ENV=development` and restart the app; the
  initializer will create the `items` table and insert three sample rows.
- To manually reset the database, stop the server and remove `app.db`, then
  restart:

```bash
rm app.db
RACK_ENV=development bundle exec rackup -p 3000
```

The development seeding lives in `db.rb` (the `DevDB#init` method).

#### Why Extralite? (SQLite alternative)

[Extralite](https://github.com/digital-fabric/extralite) provides a
zero-administration, file-backed database ideal for demos and small projects —
no separate DB server is required. It keeps the example lightweight and easy to
run locally while still showing realistic DB interactions via
[Sequel](https://sequel.jeremyevans.net/).

## Run with Docker/Podman

Build the image:

```bash
docker build -t roda-falcon-datastar .
```

Run the container (exposes port 3000):

```bash
docker run -p 3000:3000 roda-falcon-datastar
```

Visit http://0.0.0.0:3000 in your browser (`localhost` won't work with Falcon).

## Ruby Bonus: Learn the basics of Roda

Work through the wonderful web-book:
[Mastering Roda](https://fiachetti.gitlab.io/mastering-roda/).
