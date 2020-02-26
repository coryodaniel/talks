defmodule BetterTogether.PrimeCalculators.PrimesWorker do
  use GenServer
  alias BetterTogether.PrimeCalculators.Primes
  require Logger

  defmodule State do
    defstruct limit: nil, status: :not_started, elapsed_time: 0, num_primes: 0, max_prime: nil
  end

  def start_link(limit), do: GenServer.start_link(__MODULE__, %State{limit: limit})

  @doc """
  Check the results of a `PrimesWorker`
  """
  def results(pid), do: GenServer.call(pid, :results)

  # Server
  def init(state) do
    send(self(), :calculate)
    {:ok, state}
  end

  def handle_call(:results, _from, state), do: {:reply, state, state}

  def handle_info(:calculate, state) do
    Logger.info("Calculating up to: #{state.limit}")
    new_state = %State{state | status: :calculating}
    server_pid = self()

    spawn_link(fn ->
      {elapsed_time, primes} = :timer.tc(Primes, :get_primes_list, [state.limit])
      max_prime = List.last(primes)
      num_primes = length(primes)
      send(server_pid, {:report_results, {max_prime, num_primes, elapsed_time}})
    end)

    {:noreply, new_state}
  end

  @doc """
  Handles reporting results back to `PrimesWorker`
  """
  def handle_info({:report_results, {max_prime, num_primes, elapsed_time}}, state) do
    Logger.info("Reporting results: #{max_prime}")
    new_state = %State{
      state
      | elapsed_time: elapsed_time,
        status: :completed,
        max_prime: max_prime,
        num_primes: num_primes
    }

    {:noreply, new_state}
  end
end
