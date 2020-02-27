defmodule BetterTogether.PrimeCalculators.PrimesWorker do
  @moduledoc """
  GenServer worker to track the state of a `Primes` calculation.
  """
  use GenServer
  alias BetterTogether.PrimeCalculators.Primes
  require Logger

  defmodule State do
    defstruct started_at: nil,
              ended_at: nil,
              elapsed_time: 0,
              status: :initialized,
              limit: nil,
              num_primes: 0,
              max_prime: nil
  end

  def start_link(limit) do
    Logger.info("start_link: #{inspect(limit)}")
    GenServer.start_link(__MODULE__, %State{limit: limit})
  end

  @doc """
  Check the results of a `PrimesWorker`
  """
  def results(pid), do: GenServer.call(pid, :results)

  ### Server
  def init(%State{} = state) do
    Logger.info("init: #{inspect(state)}")
    Process.flag(:trap_exit, true)

    Task.async(Primes, :get_primes_list, [state.limit])
    init_state = %State{state | started_at: Time.utc_now(), status: :calculating}
    {:ok, init_state}
  end

  def handle_call(:results, _from, state), do: {:reply, state, state}

  # Handoff initiated
  def handle_call({:swarm, :begin_handoff}, _from, state) do
    # TODO: if received SIGTERM, then handoff, else ignore
    Logger.info("begin_handoff: #{inspect(state)}")
    {:reply, {:resume, state}, state}
  end

  # This is triggered whenever a process has been restarted on a new node.
  def handle_cast({:swarm, :end_handoff, incoming_state}, _current_state) do
    Logger.info("end_handoff: #{inspect(incoming_state)}")
    # TODO: should restart the Talsk if it wasn't complete
    {:noreply, incoming_state}
  end

  # called when a netsplit is resolved
  def handle_cast({:swarm, :resolve_conflict, incoming_state}, _current_state) do
    Logger.info("resolve_conflict: #{inspect(incoming_state)}")
    {:noreply, incoming_state}
  end

  # Handles calculation results from `Task` in `init/1`
  def handle_info({_task, primes}, %State{} = state) when is_list(primes) do
    ended_at = Time.utc_now()

    new_state = %State{
      state
      | elapsed_time: Time.diff(ended_at, state.started_at, :microsecond),
        ended_at: ended_at,
        status: :completed,
        num_primes: length(primes),
        max_prime: List.last(primes)
    }

    {:noreply, new_state}
  end

  # Called when process should die because it is being moved
  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  def terminate(_reason, state) do
    IO.puts "terminate: #{inspect(state)}"
    Swarm.Tracker.handoff(__MODULE__, state)
  end
end
