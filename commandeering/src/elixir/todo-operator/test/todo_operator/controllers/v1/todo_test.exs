defmodule TodoOperator.Controller.V1.TodoTest do
  @moduledoc false
  use ExUnit.Case, async: false
  alias TodoOperator.Controller.V1.Todo
  import ExUnit.CaptureLog

  def make_todo(name, state) do
    %{
      "apiVersion" => "todo-operator.bonny.run/v1",
      "kind" => "Todo",
      "metadata" => %{
        "name" => "foo-"
      },
      "spec" => %{
        "name" => name,
        "description" => "Lorem ipsum dalor",
        "state" => state
      }
    }
  end

  describe "add/1" do
    test "returns :ok" do
      event = make_todo("create-slideshow", "Pending")

      assert capture_log(fn ->
               result = Todo.modify(event)
               assert result == :ok
             end) =~ "transitioned to Pending"
    end
  end

  describe "modify/1" do
    test "returns :ok" do
      event = make_todo("create-slideshow", "Pending")

      assert capture_log(fn ->
               result = Todo.modify(event)
               assert result == :ok
             end) =~ "transitioned to Pending"
    end
  end

  describe "delete/1" do
    test "returns :ok" do
      event = make_todo("create-slideshow", "Pending")

      assert capture_log(fn ->
               result = Todo.delete(event)
               assert result == :ok
             end) =~ "Deleted todo: create-slideshow"
    end
  end

  describe "reconcile/1" do
    test "notifies Chauncy the project manager when stuff is done" do
      event = make_todo("create-slideshow", "Completed")

      assert capture_log(fn ->
               result = Todo.reconcile(event)
               assert result == :ok
             end) =~ "Email that project manager"
    end

    test "returns :ok" do
      event = make_todo("create-slideshow", "Pending")

      assert capture_log(fn ->
               result = Todo.reconcile(event)
               assert result == :ok
             end) =~ "transitioned to Pending"
    end
  end
end
