defmodule BetterTogether.PrimeCalculator.State do
  @moduledoc false
  defstruct next_odd_num: 3,
            limit: nil,
            completed: false,
            primes: nil,
            working_set: nil,
            sieve_count: 0,
            started_at: nil,
            finished_at: nil
end
