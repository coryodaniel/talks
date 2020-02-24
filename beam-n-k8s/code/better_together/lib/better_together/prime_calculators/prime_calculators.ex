defmodule BetterTogether.PrimeCalculators do
  @moduledoc """
  The PrimeCalculators context.
  """

  use DynamicSupervisor
  alias BetterTogether.PrimeCalculators.PrimesWorker

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Returns the list of prime_calculators.
  """
  def list_prime_calculators do
    __MODULE__
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
    child_spec = {PrimesWorker, limit}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def dynamic_child_to_map({_, pid, _, [mod]}) do
    pid
    |> mod.results()
    |> Map.put(:id, "#{inspect(pid)}")
  end
end
