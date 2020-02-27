defmodule BetterTogether.PrimeCalculators do
  @moduledoc """
  The PrimeCalculators context.
  """

  alias BetterTogether.PrimeCalculators.{PrimeDynamicSupervisor,PrimesWorker}

  # Swarm Group Name
  def group_name(), do: __MODULE__

  @doc """
  Returns the list of prime_calculators.
  """
  def list_prime_calculators do
    PrimeDynamicSupervisor
    |> DynamicSupervisor.which_children()
    |> Enum.map(&dynamic_child_to_map/1)
  end

  @doc """
  Creates a prime_calculator.
  """
  def create_prime_calculator(limit) when is_binary(limit) do
    case Integer.parse(limit) do
      {int, _} -> create_prime_calculator(int)
      _error -> :error
    end
  end

  def create_prime_calculator(limit) when is_integer(limit) do
    {:ok, pid} = Swarm.register_name(
      gen_name(),
      PrimeDynamicSupervisor,
      :register,
      [{PrimesWorker, limit}]
    )

    Swarm.join(group_name(), pid)
    {:ok, pid} 
  end

  def dynamic_child_to_map({_, pid, _, [mod]}) do
    pid
    |> mod.results()
    |> Map.put(:pid, pid)
  end

  @chars "abcdefghijklmnopqrstuvwxyz" |> String.split("")
  defp gen_name() do
    (1..10)
    |> Enum.reduce([], fn (_i, acc) -> [Enum.random(@chars) | acc] end) 
    |> Enum.join("")
    |> String.to_atom
  end
end
