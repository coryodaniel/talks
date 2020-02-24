defmodule BetterTogether.PrimeCalculators.PrimesTest do
  use ExUnit.Case, async: true
  alias BetterTogether.PrimeCalculators.Primes

  defp first_thousand_primes() do
    "test/support/first_1000_primes.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  test "calculates the first 1000 primes" do
    expected = first_thousand_primes()

    thousandth_prime = 7919
    primes = Primes.get_primes_list(thousandth_prime)

    assert primes == expected
    assert length(primes) == 1000
  end

  test "calculates the 100,000 prime" do
    hundred_thousandth_prime = 1_299_709

    primes = Primes.get_primes_list(hundred_thousandth_prime)
    assert List.last(primes) == hundred_thousandth_prime
    assert length(primes) == 100_000
  end
end
