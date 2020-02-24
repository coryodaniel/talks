defmodule BetterTogether.PrimeCalculators.CalcServer do
  @moduledoc """
  Starts a prime calculator

  ```elixir
  {:ok, pid} = BetterTogether.PrimeCalculators.CalcServer.start_link(10000000)
  BetterTogether.PrimeCalculators.CalcServer.status(pid)
  BetterTogether.PrimeCalculators.CalcServer.elapsed(pid)
  ```
  """
  use GenServer

  alias BetterTogether.PrimeCalculators.CalcServer.{Impl, State}

  def start_link(limit) do 
    GenServer.start_link(__MODULE__, Impl.init(limit))
  end

  def status(pid), do: GenServer.call(pid, :get_state)

  def elapsed(pid), do: GenServer.call(pid, :elapsed)

  def calculate(pid, state_with_candidates) do
    GenServer.call(pid, {:calculate, state_with_candidates})
  end

  # Server

  def init(state) do
    send(self(), :init)

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
  def handle_call({:calculate, state_with_candidates}, _from, _state) do
    send(self(), :sieve)
    {:reply, state_with_candidates, state_with_candidates}
  end

  def handle_info(:init, state) do
    server_pid = self()
    spawn_link fn -> 
      state_with_candidates = Impl.start(state)
      __MODULE__.calculate(server_pid, state_with_candidates)
    end

    # @@
    # todo: remove primes and candidates when sieve is complete, return aggs only
    # TODO: update test
    # TODO: Dont return list of primes, just return the last prime, slow to copy

    {:noreply, state}
  end

  def handle_info(:sieve, %State{completed: true} = state), do: {:noreply, state}

  def handle_info(:sieve, %State{} = state) do
    new_state = Impl.sieve(state)
    send(self(), :sieve)

    {:noreply, new_state}
  end
end
