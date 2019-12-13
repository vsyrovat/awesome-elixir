set -eu

MIX_ENV=test mix ecto.drop
mix test $@
