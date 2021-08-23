FROM elixir:1.12
WORKDIR /app
COPY . .
RUN mix local.hex --force
RUN mix deps.get
CMD mix run --no-halt
