# Understat DB
> Create a database using data from <a href='understat.com'>Understat</a>.


Understat DB is a project to scrape data from [Understat](understat.com) and store it in a Postgres database. It aims to be a useful companion or starting point for projects using football data.

## Usage

The simplest way to get started is to populate a local database with `docker-compose`.

First, clone the repository:

```bash
git clone https://github.com/Torvaney/understat-db.git
cd understat-db
```

Then, setup the local environment

```bash
make env                 # Creates a virtualenv and installs the project & dependencies
cp .env.sample .env      # Copy default environment vars to .env
```

Run the database

```bash
docker-compose up -d db  # Starts a postgres database within a docker container
understat-db migrate     # Creates base database tables
```

Finally, import the data you want

```bash
understat-db ingest --leagues EPL --seasons 2020
```


## Contributing

Pull requests are encouraged! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
