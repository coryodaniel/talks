defmodule BetterTogether.PrimeCalculator do
  @moduledoc """
  Starts a prime calculator

  ```elixir
  {:ok, pid} = BetterTogether.PrimeCalculator.start_link(10000000)
  BetterTogether.PrimeCalculator.status(pid)
  BetterTogether.PrimeCalculator.elapsed(pid)
  ```
  """
  use GenServer

  alias BetterTogether.PrimeCalculator.{Impl, State}

  def start_link(limit), do: GenServer.start_link(__MODULE__, %State{limit: limit})

  def status(pid), do: GenServer.call(pid, :get_state)

  def elapsed(pid), do: GenServer.call(pid, :elapsed)

  # Server

  def init(state) do
    send(self(), :start)

    {:ok, state}
  end

  @doc """
  Returning the total time 
  """
  def handle_call(:elapsed, _from, %State{} = state) do
    elapsed_time = Impl.elapsed(state)

    {:reply, elapsed_time, state}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_info(:start, state) do
    new_state = Impl.init(state)
    send(self(), :sieve)

    {:noreply, new_state}
  end

  def handle_info(:sieve, %State{completed: true} = state), do: {:noreply, state}

  def handle_info(:sieve, %State{} = state) do
    new_state = Impl.sieve(state)
    send(self(), :sieve)

    {:noreply, new_state}
  end
end
