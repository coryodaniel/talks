defmodule BetterTogether.PrimeCalculators.PrimesWorkerTest do
  use ExUnit.Case, async: true
  alias BetterTogether.PrimeCalculators.PrimesWorker

  defp wait_for_primes(pid) do
    case PrimesWorker.results(pid) do
      %{max_prime: nil} -> wait_for_primes(pid)
      %{max_prime: _int} = state -> state
    end
  end

  test "calculates the first 1000 primes" do
    thousandth_prime = 7919
    {:ok, pid} = PrimesWorker.start_link(thousandth_prime)

    %{
      max_prime: max_prime,
      num_primes: num_primes,
      status: status,
      elapsed_time: elapsed_time
    } = wait_for_primes(pid)

    assert status == :completed
    assert max_prime == thousandth_prime
    assert num_primes == 1000
    assert elapsed_time > 0
  end
end
