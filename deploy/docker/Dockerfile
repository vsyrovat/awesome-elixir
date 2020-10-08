FROM hexpm/elixir:1.10.4-erlang-22.3.4.10-alpine-3.12.0 AS build

RUN apk add --no-cache build-base npm git python2

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

# ENV LC_ALL=en_US.utf8
# RUN ulimit -n 16384

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only prod, deps.compile

COPY assets/package.json assets/package-lock.json ./assets/
# RUN cd assets; npm i && node_modules/webpack/bin/webpack.js --mode production; cd -
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release


FROM alpine:3.12.0 AS app
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/app ./

ENV HOME=/app

CMD ["bin/app", "start"]
