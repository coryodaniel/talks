defmodule TodoOperator.Controller.V1.Todo do
  use Bonny.Controller
  require Logger

  @group "todo-operator.bonny.run"
  @scope :namespaced
  @names %{plural: "todos", singular: "todo", kind: "Todo"}

  @doc "Handles an `ADDED` event"
  @spec add(map()) :: :ok | :error
  @impl Bonny.Controller
  def add(todo), do: reconcile(todo)

  @doc "Handles a `MODIFIED` event"
  @spec modify(map()) :: :ok | :error
  @impl Bonny.Controller
  def modify(todo), do: reconcile(todo)

  @doc "Handles a `DELETED` event"
  @spec delete(map()) :: :ok | :error
  @impl Bonny.Controller
  def delete(%{"spec" => %{"name" => name}}) do
    Logger.info("Deleted todo: #{name}. Can we go home early?")
  end

  @doc "Called periodically for each existing CustomResource to allow for reconciliation."
  @spec reconcile(map()) :: :ok | :error
  @impl Bonny.Controller
  def reconcile(%{"spec" => %{"name" => name, "state" => "Completed"}} = _todo) do
    Logger.info("WOOHOO #{name} was completed! Email that project manager!!!")
  end

  def reconcile(%{"spec" => %{"name" => name, "state" => state}} = _todo) do
    Logger.info("Todo: #{name} transitioned to #{state}")
  end
end
