# Как прекрасен Elixir, посмотри

Приложение собрано на ЯП [Elixir](https://elixir-lang.org/) и фреймворке [Phoenix](https://www.phoenixframework.org/) и представляет собой задание [Awesome Elixir](https://dl.funbox.ru/qt-elixir.pdf).

Приложение получает список репозиториев из [Awesome Elixir readme](https://github.com/h4cc/awesome-elixir), затем для каждого репозитория определяет количество звёзд и дату-время последнего коммита. Полученные данные актуализируются раз в сутки.


## Системные требования

Для запуска приложения понадобятся Erlang и Elixir, для компиляции ассетов понадобится Nodejs (версии интерпретаторов можно посмотреть [здесь](.tool-versions), либо используйте [asdf-vm](https://asdf-vm.com/)).

Понадобятся Docker и Docker-Compose для запуска Postgres, либо, если у вас настроен Postgres - можете использовать его.

Приложение писалось и тестировалось на GNU/Linux-сборке.


## Запуск для разработки (dev)

1. `mix deps.get` - чтобы установить пакеты Elixir.
2. `cd assets && npm install` - чтобы установить пакеты Nodejs.
3. `./env-up.sh` - чтобы запустить Postgres (предварительно ознакомьтесь с [docker-compose.yml]). Либо используйте свою Postgres, и тогда проверьте настройки в файле [config/dev.exs].
4. `cd config && cp dev.secret.exs.dist dev.secret.exs`
4а. В файле `dev.secret.exs` указываете либо свой [Github Api Token](https://github.com/settings/tokens) (см. ниже).
5. `mix ecto.create && mix ecto.migrate`. Делать mix ecto.setup **не надо**.
6. `mix phx.server`
7. Откройте в браузере `http://127.0.0.1:4000`

При старте дерева супервизора (`mix phx.server` или `iex -S mix`) сразу запустится наполнение локальной базы данных.
По мере заполнения локальной базу информация о репозиториях будет становиться доступна в браузере (нужно обновлять страницу по F5).
После наполнения приложение будет актуализировать данные самостоятельно.

## Запуск тестов (test)

1. `mix deps.get`
2. `./env-up.sh`
3. `MIX_ENV=test mix ecto.create`
4. `mix test`


## Запуск в продакшне (prod)

В проде нужно передать в окружение переменные `DATABASE_URL`, `SECRET_KEY_BASE`, `GITHUB_API_TOKEN` (опционально, по умолчанию nil), `LISTEN_IP` (опционально, по умолчанию 127.0.0.1), `PORT` (опционально, по умолчанию 4000), `MIX_ENV=prod`.

LISTEN_IP можно использовать если вы запускаете приложение без реверс-прокси (LISTEN_IP=0.0.0.0).


## Github Api Token

Приложение чекает репозитории именно на github.com. Github API позволяет в час 60 анонимных запросов и до 5000 неанонимных. Это означает, что если вы укажете токен - информация о репозиториях будет обновлена в течение нескольких минут, если не укажете - в течение суток (на момент написания приложения в Awesome-листе примерно 1300 репозиториев).

Токен для dev указывается в файле config/dev.secret.exs:
```
use Mix.Config
config :app, github_api_token: "ваш-токен-здесь"
```

либо

```
use Mix.Config
config :app, github_api_token: nil
```

Токен для prod указывается в переменной окружения GITHUB_API_TOKEN.

## Лицензия/License

MIT