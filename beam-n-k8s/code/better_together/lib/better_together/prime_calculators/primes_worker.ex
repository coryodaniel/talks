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

  ### Server
  def init(%State{} = state) do
    Task.async(Primes, :get_primes_list, [state.limit])
    init_state = %State{state | started_at: Time.utc_now(), status: :calculating}
    {:ok, init_state}
  end

  def handle_call(:results, _from, state), do: {:reply, state, state}

  # called when a handoff has been initiated due to changes
  # in cluster topology, valid response values are:
  #
  #   - `:restart`, to simply restart the process on the new node
  #   - `{:resume, state}`, to hand off some state to the new process
  #   - `:ignore`, to leave the process running on its current node
  #
  def handle_call({:swarm, :begin_handoff}, _from, state) do
    # TODO: if received SIGTERM, then handoff, else ignore
    {:reply, {:resume, state}, state}
  end

  # This is triggered whenever a process has been restarted on a new node.
  def handle_cast({:swarm, :end_handoff, incoming_state}, _current_state) do
    # TODO: should restart the task if it wasn't complete
    {:noreply, incoming_state}
  end
  
  # called when a network split is healed and the local process
  # should continue running, but a duplicate process on the other
  # side of the split is handing off its state to us. You can choose
  # to ignore the handoff state, or apply your own conflict resolution
  # strategy
  def handle_cast({:swarm, :resolve_conflict, _incoming_state}, state) do
    {:noreply, state}
  end

  @doc """
  Handles reporting results back to `Task`
  """  
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

  # this message is sent when this process should die
  # because it is being moved, use this as an opportunity
  # to clean up
  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end

  def handle_info(_, state), do: {:noreply, state}    
end
