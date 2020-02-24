defmodule BetterTogether.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BetterTogetherWeb.Endpoint,
      {DynamicSupervisor, strategy: :one_for_one, name: BetterTogether.PrimeCalculators}
    ]

    opts = [strategy: :one_for_one, name: BetterTogether.Supervisor]
    supervisor = Supervisor.start_link(children, opts)

    start_calcs([1000, 5000, 10000, 20000])

    supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BetterTogetherWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_calcs(defaults) do
    Enum.each(defaults, fn limit ->
      BetterTogether.PrimeCalculators.create_prime_calculator(limit)
    end)
  end
end
