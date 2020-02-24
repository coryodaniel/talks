defmodule BetterTogether.PrimeCalculator.Impl do
  @moduledoc """
  Calculates prime numbers

  Credit [github.com/ybod](https://github.com/ybod/elixir_primes)
  """

  def init_state(limit) when limit == 2 do
    %{limit: 2, completed: true, primes: [2], working_set: nil}
  end

  def init_state(limit) when limit > 2 do
    odd_integers = :lists.seq(3, limit, 2)
    working_set = MapSet.new([2 | odd_integers])

    %{limit: limit, completed: false, primes: nil, working_set: working_set}
  end

  # Sieving: all primes already found, no need to look furhter
  def sieve(set, odd_num, limit) when odd_num * odd_num > limit do
    primes =
      set
      |> MapSet.to_list()
      |> Enum.sort()

    {:completed, primes}
  end

  # Check if the next odd number can be found is the Set.
  # If found - it's a prime number and we need to remove all multiples of this prime from Set.
  def sieve(set, odd_num, limit) do
    new_set =
      if MapSet.member?(set, odd_num), do: delete_composites(odd_num, set, limit), else: set

    {:not_completed, new_set}
  end

  defp delete_composites(first, set, limit) do
    composites =
      :lists.seq(first * first, limit, 2 * first)
      |> MapSet.new()

    MapSet.difference(set, composites)
  end
end
