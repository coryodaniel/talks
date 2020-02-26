#########################
###### Build Image ######
#########################

FROM bitwalker/alpine-elixir-phoenix:1.9.4 as builder

WORKDIR /app

ENV MIX_ENV=prod \
  MIX_HOME=/opt/mix \
  HEX_HOME=/opt/hex

RUN mix do local.hex --force, local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . .
RUN mix compile
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest
RUN mix release

#########################
##### Release Image #####
#########################

FROM alpine:3.10

RUN apk add --update openssl ncurses bind-tools

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/better_together ./
RUN chown -R nobody: /app

ENTRYPOINT ["/app/bin/better_together"]
CMD ["start"]