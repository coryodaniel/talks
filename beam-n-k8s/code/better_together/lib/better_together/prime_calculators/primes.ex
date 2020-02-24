defmodule BetterTogether.PrimeCalculators.Primes do
  @moduledoc """
  Calculates prime numbers up to a limit.

  Credit: [github.com/ybod/](https://github.com/ybod/elixir_primes/blob/master/lib/sieve_of_eratosthenes_mapset.ex)
  """

  alias Primes.Helper.Sequence

  @doc """
  Returns the list of the prime numbers up to the given limit. Limit must be integer and larger than 1.

  """
  @spec get_primes_list(pos_integer) :: [pos_integer]
  def get_primes_list(limit) when limit == 2, do: [2]

  def get_primes_list(limit) when limit > 2 do
    odd_integers = :lists.seq(3, limit, 2)
    set = MapSet.new([2 | odd_integers])

    sieve(set, 3, limit)
  end

  # Sieving: all primes already found, no need to look furhter
  defp sieve(set, odd_num, limit) when odd_num * odd_num > limit do
    MapSet.to_list(set)
    |> Enum.sort()
  end

  # Check if the next odd number can be found is the Set.
  # If found - it's a prime number and we need to remove all multiples of this prime from Set.
  defp sieve(set, odd_num, limit) do
    new_set =
      if MapSet.member?(set, odd_num), do: delete_composites(odd_num, set, limit), else: set

    sieve(new_set, odd_num + 2, limit)
  end

  defp delete_composites(first, set, limit) do
    composites =
      :lists.seq(first * first, limit, 2 * first)
      |> MapSet.new()

    MapSet.difference(set, composites)
  end
end
