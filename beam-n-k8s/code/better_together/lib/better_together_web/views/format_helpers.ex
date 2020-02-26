defmodule BetterTogetherWeb.FormatHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def format_number(num) when is_integer(num) do
    num
    |> Integer.to_charlist()
    |> Enum.reverse()
    |> Enum.chunk_every(3, 3, [])
    |> Enum.join(",")
    |> String.reverse()
  end

  def format_number(other), do: other
end
