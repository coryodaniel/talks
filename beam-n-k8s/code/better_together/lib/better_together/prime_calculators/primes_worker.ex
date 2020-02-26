defmodule BetterTogether.PrimeCalculators.PrimesWorker do
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

  def handle_info(_, state), do: {:noreply, state}
end
