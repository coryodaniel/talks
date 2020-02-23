defmodule BetterTogether.PrimeCalculatorTest do
  use ExUnit.Case, async: true

  test "calculates the first 1000 primes" do
    {:ok, file} = File.read("test/support/first_1000_primes.txt")
    thousandth_prime = 7919
    primes = BetterTogether.PrimeCalculator.get_primes_list(thousandth_prime)

    expected =
      file
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    assert primes == expected
  end

  test "calculates the 100,000 prime" do
    hundred_thousandth_prime = 1_299_709

    primes = BetterTogether.PrimeCalculator.get_primes_list(hundred_thousandth_prime)
    assert List.last(primes) == hundred_thousandth_prime
  end
end
