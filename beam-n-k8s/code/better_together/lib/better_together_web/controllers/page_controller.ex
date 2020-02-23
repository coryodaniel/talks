defmodule BetterTogetherWeb.PageController do
  use BetterTogetherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
