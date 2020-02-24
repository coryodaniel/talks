defmodule BetterTogether.PrimeCalculators.CalcServerTest do
  use ExUnit.Case, async: true
  alias BetterTogether.PrimeCalculators.CalcServer

  defp first_thousand_primes() do
    "test/support/first_1000_primes.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  defp wait_for_primes(pid) do
    case CalcServer.status(pid) do
      %{primes: []} -> wait_for_primes(pid)
      %{primes: primes} -> primes
      # %{max_prime: nil} -> wait_for_primes(pid)
      # %{max_prime: prime} -> prime      
    end
  end

  test "calculates the first 1000 primes" do
    expected = first_thousand_primes()

    thousandth_prime = 7919
    {:ok, pid} = CalcServer.start_link(thousandth_prime)
    primes = wait_for_primes(pid)

    assert primes == expected
  end

  test "calculates the 100,000 prime" do
    hundred_thousandth_prime = 1_299_709
    {:ok, pid} = CalcServer.start_link(hundred_thousandth_prime)

    primes = wait_for_primes(pid)
    assert List.last(primes) == hundred_thousandth_prime
  end

  test "counts the sieves" do
    thousandth_prime = 7919
    {:ok, pid} = CalcServer.start_link(thousandth_prime)
    wait_for_primes(pid)

    %{sieve_count: count} = CalcServer.status(pid)
    assert count == 43
  end

  describe "elapsed/1" do
    test "calculates elapsed time" do
      thousandth_prime = 7919
      {:ok, pid} = CalcServer.start_link(thousandth_prime)
      wait_for_primes(pid)

      microseconds = CalcServer.elapsed(pid)
      assert microseconds < 10000
    end
  end
end
