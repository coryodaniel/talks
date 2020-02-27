defmodule BetterTogetherWeb.Plugs.Health do
  import Plug.Conn

  def init(_opts) do
    %{}
  end

  def call(%Plug.Conn{} = conn, %{}) do
    conn
    |> send_resp(200, "OK")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
