defmodule BetterTogether.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      {Cluster.Supervisor, [topologies, [name: BetterTogether.ClusterSupervisor]]},
      BetterTogetherWeb.Endpoint,
      {DynamicSupervisor,
       strategy: :one_for_one, name: BetterTogether.PrimeCalculators.PrimeDynamicSupervisor}
    ]

    opts = [strategy: :one_for_one, name: BetterTogether.Supervisor]
    supervisor = Supervisor.start_link(children, opts)

    # start_calcs(:fast)
    # start_calcs(:slow)

    supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BetterTogetherWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_calcs(:fast) do
    fast = [1_000]

    Enum.each(fast, fn limit ->
      BetterTogether.PrimeCalculators.create_prime_calculator(limit)
    end)
  end

  def start_calcs(:slow) do
    # slow_occurrences = :erlang.system_info(:logical_processors)    
    slow_occurrences = 1

    # Takes about 2 min on my macbook
    slow_limit = 100_000_000
    slow = List.duplicate(slow_limit, slow_occurrences)

    Enum.each(slow, fn limit ->
      BetterTogether.PrimeCalculators.create_prime_calculator(limit)
    end)
  end
end
