defmodule CpuSchedulers.Stats do
  @moduledoc "VM Stats"

  use GenServer
  require Logger

  @frequency 1_000
  @stats [
    :active_tasks,
    :active_tasks_all,
    :context_switches,
    # :garbage_collection,
    # :io,
    # :microstate_accounting, # system_flag(:microstate_accounting, true)
    # :reductions,
    :run_queue,
    :run_queue_lengths,
    :run_queue_lengths_all,
    :runtime,
    # :scheduler_wall_time,
    # :scheduler_wall_time_all,
    :total_active_tasks,
    :total_active_tasks_all,
    :total_run_queue_lengths,
    :total_run_queue_lengths_all
    # :wall_clock
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_log_stats()
    {:ok, state}
  end

  @impl true
  def handle_info(:log_stats, state) do
    stats()
    |> Jason.encode!()
    |> Logger.info()

    schedule_log_stats()
    {:noreply, state}
  end

  def schedulers do
    %{
      schedulers: :erlang.system_info(:schedulers),
      schedulers_online: :erlang.system_info(:schedulers_online)
    }
  end

  def stats do
    schedulers()
    # Enum.reduce(@stats, schedulers(), fn stat, acc ->
    #   val = :erlang.statistics(stat)
    #   Map.put(acc, stat, val)
    # end)
  end

  defp schedule_log_stats() do
    Process.send_after(self(), :log_stats, @frequency)
  end
end
