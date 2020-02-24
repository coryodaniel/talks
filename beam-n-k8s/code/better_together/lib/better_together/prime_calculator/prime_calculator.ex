defmodule BetterTogether.PrimeCalculator do
  use GenServer

  alias BetterTogether.PrimeCalculator.Impl

  def start_link(limit) do
    GenServer.start_link(__MODULE__, limit)
  end

  def status(pid) do
    GenServer.call(pid, :get_state)
  end

  # Server

  def init(limit) do
    IO.puts("Starting #{limit}")
    state = Impl.init_state(limit)
    send(self(), {:sieve, 3})
    {:ok, state}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_info({:sieve, _odd_num}, %{completed: true} = state), do: {:noreply, state}
  def handle_info({:sieve, odd_num}, %{working_set: set, limit: limit} = state) do
    new_state =
      case Impl.sieve(set, odd_num, limit) do
        {:completed, primes} ->
          state
          |> Map.put(:completed, true)
          |> Map.put(:primes, primes)

        {:not_completed, new_set} ->
          send(self(), {:sieve, odd_num + 2})
          Map.put(state, :working_set, new_set)
      end

    {:noreply, new_state}
  end
end
