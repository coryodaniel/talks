defmodule BetterTogether.PrimeCalculators do
  @moduledoc """
  The PrimeCalculators context.
  """

  alias BetterTogether.PrimeCalculators.PrimeCalculator

  @doc """
  Returns the list of prime_calculators.
  """
  def list_prime_calculators do
    []
    #Repo.all(PrimeCalculator)
  end

  @doc """
  Gets a single prime_calculator.
  """
  def get_prime_calculator!(id), do: :ok #Repo.get!(PrimeCalculator, id)

  @doc """
  Creates a prime_calculator.
  """
  def create_prime_calculator(attrs \\ %{}) do
    # %PrimeCalculator{}
    # |> PrimeCalculator.changeset(attrs)
    # |> Repo.insert()
    {:ok, "foo"}
  end
end
