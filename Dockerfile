FROM elixir:1.11.3-alpine

RUN mkdir /app

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix local.hex --force && mix local.rebar --force

RUN mix deps.get && mix deps.compile

COPY . .

EXPOSE 4000

CMD ["mix", "phx.server"]