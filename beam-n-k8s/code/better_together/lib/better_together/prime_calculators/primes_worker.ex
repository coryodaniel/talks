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

  def start_link(limit), do: GenServer.start_link(__MODULE__, %State{limit: limit})

  @doc """
  Check the results of a `PrimesWorker`
  """
  def results(pid), do: GenServer.call(pid, :results)

  ###################################################
  ###
  ### Server
  ###
  ###################################################

  def init(%State{} = state) do
    Process.flag(:trap_exit, true)

    Task.async(Primes, :get_primes_list, [state.limit])
    init_state = %State{state | started_at: Time.utc_now(), status: :calculating}
    {:ok, init_state}
  end

  def handle_call(:results, _from, state), do: {:reply, state, state}

  # Handoff initiated
  # TODO: if received SIGTERM, then handoff, else ignore  
  def handle_call({:swarm, :begin_handoff}, _from, state), do: {:reply, {:resume, state}, state}

  # This is triggered whenever a process has been restarted on a new node.
  # TODO: should restart the Task if it wasn't complete  
  def handle_cast({:swarm, :end_handoff, incoming_state}, _current_state),
    do: {:noreply, incoming_state}

  # called when a netsplit is resolved
  def handle_cast({:swarm, :resolve_conflict, incoming_state}, _current_state),
    do: {:noreply, incoming_state}

  # Handles calculation results from `Task` in `init/1`
  def handle_info({_task, primes}, %State{} = state) when is_list(primes),
    do: {:noreply, state_with_primes(state, primes)}

  # Called when process should die because it is being moved
  def handle_info({:swarm, :die}, state), do: {:stop, :shutdown, state}

  def handle_info(_, state), do: {:noreply, state}

  def terminate(_reason, state), do: Swarm.Tracker.handoff(__MODULE__, state)

  defp state_with_primes(%State{} = state, primes) do
    ended_at = Time.utc_now()

    %State{
      state
      | elapsed_time: Time.diff(ended_at, state.started_at, :microsecond),
        ended_at: ended_at,
        status: :completed,
        num_primes: length(primes),
        max_prime: List.last(primes)
    }
  end
end
