defmodule BetterTogether.PrimeCalculator.Impl do
  @moduledoc """
  Calculates prime numbers

  Credit [github.com/ybod](https://github.com/ybod/elixir_primes)
  """

  alias BetterTogether.PrimeCalculator.State

  def init(%State{limit: limit}) when limit == 2 do
    now = now()
    %State{limit: 2, completed: true, primes: [2], started_at: now, finished_at: now}
  end

  def init(%State{limit: limit}) when limit > 2 do
    odd_integers = :lists.seq(3, limit, 2)
    working_set = MapSet.new([2 | odd_integers])

    %State{
      limit: limit,
      completed: false,
      working_set: working_set,
      started_at: now(),
      next_odd_num: 3
    }
  end

  def elapsed(%State{started_at: started_at, finished_at: maybe_finished_at}) do
    finished_at =
      case maybe_finished_at do
        nil -> now()
        finished_at -> finished_at
      end

    Time.diff(finished_at, started_at, :microsecond)
  end

  # Sieving: all primes already found, no need to look furhter
  def sieve(%State{working_set: set, limit: limit, next_odd_num: odd_num} = state)
      when odd_num * odd_num > limit do
    primes =
      set
      |> MapSet.to_list()
      |> Enum.sort()

    %State{state | completed: true, primes: primes, finished_at: now()}
  end

  # Check if the next odd number can be found is the Set.
  # If found - it's a prime number and we need to remove all multiples of this prime from Set.
  def sieve(
        %State{working_set: set, limit: limit, next_odd_num: odd_num, sieve_count: count} = state
      ) do
    new_set =
      if MapSet.member?(set, odd_num), do: delete_composites(odd_num, set, limit), else: set

    %State{state | working_set: new_set, next_odd_num: odd_num + 2, sieve_count: count + 1}
  end

  defp delete_composites(first, set, limit) do
    composites =
      :lists.seq(first * first, limit, 2 * first)
      |> MapSet.new()

    MapSet.difference(set, composites)
  end

  defp now(), do: Time.utc_now()
end
