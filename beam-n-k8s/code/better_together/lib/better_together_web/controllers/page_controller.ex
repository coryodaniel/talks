defmodule BetterTogetherWeb.PageController do
  use BetterTogetherWeb, :controller

  def index(conn, _) do
    render(conn, "index.html")
  end
end
