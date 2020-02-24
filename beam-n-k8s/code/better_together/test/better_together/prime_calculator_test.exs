defmodule BetterTogether.PrimeCalculatorTest do
  use ExUnit.Case, async: true

  defp first_thousand_primes() do
    "test/support/first_1000_primes.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  defp wait_for_primes(pid) do
    case BetterTogether.PrimeCalculator.status(pid) do
      %{primes: nil} -> wait_for_primes(pid)
      %{primes: primes} -> primes
    end
  end

  test "calculates the first 1000 primes" do
    expected = first_thousand_primes()

    thousandth_prime = 7919
    {:ok, pid} = BetterTogether.PrimeCalculator.start_link(thousandth_prime)
    primes = wait_for_primes(pid)

    assert primes == expected
  end

  test "calculates the 100,000 prime" do
    hundred_thousandth_prime = 1_299_709
    {:ok, pid} = BetterTogether.PrimeCalculator.start_link(hundred_thousandth_prime)

    primes = wait_for_primes(pid)
    assert List.last(primes) == hundred_thousandth_prime
  end

  test "counts the sieves" do
    thousandth_prime = 7919
    {:ok, pid} = BetterTogether.PrimeCalculator.start_link(thousandth_prime)
    wait_for_primes(pid)

    %{sieve_count: count} = BetterTogether.PrimeCalculator.status(pid)
    assert count == 43
  end

  describe "elapsed/1" do
    test "calculates elapsed time" do
      thousandth_prime = 7919
      {:ok, pid} = BetterTogether.PrimeCalculator.start_link(thousandth_prime)
      wait_for_primes(pid)

      microseconds = BetterTogether.PrimeCalculator.elapsed(pid)
      assert microseconds < 10000
    end
  end
end
