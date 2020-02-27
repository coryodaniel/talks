defmodule BetterTogether.PrimeCalculators do
  @moduledoc """
  The PrimeCalculators context.
  """

  @group_name :calculators
  @chars "abcdefghijklmnopqrstuvwxyz" |> String.split("")

  alias BetterTogether.PrimeCalculators.{PrimeDynamicSupervisor, PrimesWorker}

  @doc """
  Returns the list of prime_calculators.
  """
  def list_prime_calculators do
    @group_name
    |> Swarm.members()
    |> Enum.reduce([], fn pid, acc ->
      node = :erlang.node(pid)
      calc_state = :rpc.call(node, PrimesWorker, :results, [pid])
      calc_loc = %{pid: pid, node: node}
      calc = Map.merge(calc_state, calc_loc)

      [calc | acc]
    end)
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
    {:ok, pid} =
      Swarm.register_name(
        gen_name(),
        PrimeDynamicSupervisor,
        :register,
        [{PrimesWorker, limit}]
      )

    Swarm.join(@group_name, pid)
    {:ok, pid}
  end

  defp gen_name() do
    1..10
    |> Enum.reduce([], fn _i, acc -> [Enum.random(@chars) | acc] end)
    |> Enum.join("")
    |> String.to_atom()
  end
end
