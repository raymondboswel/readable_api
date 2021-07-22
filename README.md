## Working with Docker
In order to get up and running in as little time as possible, the project makes use of docker.

### Getting started

1. Download and install docker and docker-compose for you specific operating system by following the instructions posted [here](https://docs.docker.com/get-docker/)

2. Run `docker-compose run readable_api mix ecto.setup` to setup your database.

3. Run `docker-compose up` to start working.

### Development tasks

  * Install dependencies with `docker-compose run readable_api mix deps.get`
  * Reset you database with `docker-compose run readable_api mix ecto.reset`
  * Access the iex console `docker-compose run readable_api iex`
  * Migrate new migrations `docker-compose run readable_api mix ecto.migrate`
  * Check migrations status `docker-compose run readable_api mix ecto.migrations`
  * Rollback a migration `docker-compose run readable_api mix ecto.rollback`
  * Run tests `docker-compose run -e DOC=1 readable_api mix test --only fixed_tests`

  * After tests have been executed, html api docs can updated with
  ```cd assets && yarn run generate:docs```

## Deploying

FoodGuru uses asdf to build releases for deploys. Run the following commands in your home directory on the deploy server.

## Setting up asdf

### [Installing asdf](https://asdf-vm.com/#/core-manage-asdf-vm?id=install)

Install asdf into your home directory from git
`git clone https://github.com/asdf-vm/asdf.git ~/.asdf`

Add asdf to your bash shell
```
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
```

At this point it is recommended that you restart your shell.

### [Add elixir and erlang plugins to asdf](https://asdf-vm.com/#/core-manage-plugins)

```
asdf plugin add elixir
asdf plugin add erlang
```

### [Install the project elixir and erlang](https://asdf-vm.com/#/core-commands)

Navigate to the project in the shell and run the following command

`asdf install`

You should now be ready to go as soon as the install finishes.



## Debugging in production

To  view the latest logs interactively use:
```
tail -f /var/log/readable_api/error.log
```
To remotely connect to IEX, first cd into the current directory, then use:
```
bin/readable_api remote
```
To view the migration history, first cd into the current directory then use:
```
bin/readable_api rpc "Release.Migrate.migrations"
```
To run all migrations, first cd into the current directory then use:
```
bin/readable_api rpc "Release.Migrate.migrate"
```
To rollback migrations, first cd into the current directory then use:
```
bin/readable_api rpc "Release.Migrate.rollback"
```


# ReadableApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
