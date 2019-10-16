# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, level: :info

config :bonny,
  group: "todo-operator.bonny.run",
  controllers: [
    TodoOperator.Controller.V1.Todo
  ]

import_config "#{Mix.env()}.exs"
