# Elixir/Phoenix Docker Image

# Image based on alpine linux. Smaller than full elixir variant
# Unfortunately build tools increase image size, but are required for development.

# To build run:
#	docker build -t fastcomm/readable_api:dev ./

FROM elixir:1.11.2-alpine
# Metadata
LABEL "maintainer"="Raymond Boswel" "appname"="Phoenix Server"

# Grab dependencies
RUN apk update && \
	apk add inotify-tools libgcc libstdc++ libx11 glib libxrender libxext libintl \
	ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family build-base npm \
	&& rm -rf /var/cache/apk/*

# Create a group and user
RUN addgroup --gid 1000 --system fc_group && adduser --system --uid 1000 fc_user --ingroup fc_group

# Setup project source code
ENV APP_HOME /home/fc_user/readable_api
RUN mkdir $APP_HOME
COPY ./ $APP_HOME

RUN chown -R 1000:1000 $APP_HOME

USER fc_user

WORKDIR $APP_HOME

RUN mix local.hex --force && \
	mix archive.install hex phx_new 1.5.8 --force && \
	mix local.rebar --force

# Important to clean dependencies and rebuild on alpine
RUN mix deps.clean --all && mix deps.get && mix deps.compile

# Run the phoenix server
CMD mix ecto.setup && mix phx.server
