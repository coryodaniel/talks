defmodule Affinity.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Affinity.Stats, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end
end
