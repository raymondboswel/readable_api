# Fastcomm Phoenix Template
The aim of this project is to provide a solid starting point for new projects, ideally allowing developers to get started on implementation from day1

## Working with Docker
In order to get up and running in as little time as possible, the project makes use of docker.

### Getting started

1. Download and install docker and docker-compose for you specific operating system by following the instructions posted [here](https://docs.docker.com/get-docker/)

2. Run `docker-compose run phoenix_template mix ecto.setup` to setup your database.

3. Run `docker-compose up` to start working.

4. // Ask a developer on the project to share their dev.secret.exs and copy it to `phoenix_template/config/dev.secret.exs`.

### Development tasks

  * Install dependencies with `docker-compose run phoenix_template mix deps.get`
  * Reset you database with `docker-compose run phoenix_template mix ecto.reset`
  * Access the iex console `docker-compose run phoenix_template iex`
  * Migrate new migrations `docker-compose run phoenix_template mix ecto.migrate`
  * Check migrations status `docker-compose run phoenix_template mix ecto.migrations`
  * Rollback a migration `docker-compose run phoenix_template mix ecto.rollback`
  * Run tests `docker-compose run -e DOC=1 phoenix_template mix test --only fixed_tests`

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
tail -f /var/log/phoenix_template/error.log
```
To remotely connect to IEX, first cd into the current directory, then use:
```
bin/phoenix_template remote
```
To view the migration history, first cd into the current directory then use:
```
bin/phoenix_template rpc "Release.Migrate.migrations"
```
To run all migrations, first cd into the current directory then use:
```
bin/phoenix_template rpc "Release.Migrate.migrate"
```
To rollback migrations, first cd into the current directory then use:
```
bin/phoenix_template rpc "Release.Migrate.rollback"
```


# Mimic the production setup.
The standard setup aims to mimic the production setup approximately, however, is has a few point where it deviates 
significantly from what a developer would experience when developing on a production environment:
- The existence of primary and secondary servers. 
- Domain names, especially subdomain names that affect business logic.
The first point forces the BE to be stateless, and it is not always easy to always test the consequences of having multiple 
servers interact with the database. Sometimes you might want to test clustering, sometimes you might want to have a task execute
on only one server. For these cases you might want to try and get even closer to the full production setup. 
## Setup
The steps to produce a 
more realistic setup is slightly more involved and requires that you setup local wildcard hostnames. This will differ between OS's
however, for linux the steps are simple:
Edit the file `/etc/NetworkManager/NetworkManager.conf`, and add the line `dns=dnsmasq` to the `[main]` section, it will look like this:
```
[main]
plugins=ifupdown,keyfile
dns=dnsmasq

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
```
Let NetworkManager manage `/etc/resolv.conf`:
```
sudo rm /etc/resolv.conf ; sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
```
Configure phoenix_template.local
```
echo 'address=/.phoenix_template.local/127.0.0.1' | sudo tee /etc/NetworkManager/dnsmasq.d/phoenix_template.local-wildcard.conf
```
NetworkManager should be reloaded for the changes to take effect.
```
sudo systemctl reload NetworkManager
```
Verify that your DNS is still operational:
```
dig askubuntu.com +short
151.101.129.69
151.101.65.69
151.101.1.69
151.101.193.69
```
And lastly verify that the phoenix_template.local and subdomains are resolved as 127.0.0.1:
```
dig phoenix_template.local  +short
127.0.0.1
127.0.0.1
127.0.0.1
```
Depending on your OS you might need to add an entry for `phoenix_template.local` in your `/etc/hosts` file pointing to `127.0.0.1` as well.
Ensure the Nginx block is uncommented in the `docker-compose.yml` file, and ensure all required services are uncommented as well.
## Different configurations
By default, primary will run all migrations and seeds, which means secondary should connect first the majority of the time.
To test handover the steps are to stop the container running secondary, and then to run:
```
docker-compose run foodguru.secondary iex --name foodguru@foodguru.secondary --cookie ek61maXukrWtkC6m9MjgmSxXroM3OIcG -S mix phx.server
```
From the console you can access the processes and kill and restart as you wish. You can also stop primary and restart it in a similar manner.


# PhoenixTemplate

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
