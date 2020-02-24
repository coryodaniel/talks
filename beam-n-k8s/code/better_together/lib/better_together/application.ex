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

    start_calcs()

    supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BetterTogetherWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_calcs() do
    defaults = [1_000, 10_000, 100_000, 1_000_000, 10_000_000]

    Enum.each(defaults, fn limit ->
      BetterTogether.PrimeCalculators.create_prime_calculator(limit)
    end)

    # Takes about 2 min on my macbook
    slow_limit = 100_000_000
    slow_occurrences = :erlang.system_info(:logical_processors)    
    slow = List.duplicate(slow_limit, slow_occurrences)

    Enum.each(slow, fn limit ->
      BetterTogether.PrimeCalculators.create_prime_calculator(limit)
    end)
  end
end
