defmodule BetterTogether.PrimeCalculators.PrimeDynamicSupervisor do
  @moduledoc """
  DynamicSupervisor of `PrimesWorker`
  """

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def register(worker_name) do
    DynamicSupervisor.start_child(__MODULE__, worker_name)
  end  
end
