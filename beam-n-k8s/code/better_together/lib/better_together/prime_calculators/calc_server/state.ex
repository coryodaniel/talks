defmodule BetterTogether.PrimeCalculators.CalcServer.State do
  @moduledoc false
  defstruct next_odd_num: 3,
            limit: nil,
            completed: false,
            num_primes: nil,
            max_prime: nil,
            primes: [],
            candidates: nil,
            sieve_count: 0,
            started_at: nil,
            finished_at: nil
end
