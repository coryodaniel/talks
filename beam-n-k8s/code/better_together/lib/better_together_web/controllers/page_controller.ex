defmodule BetterTogetherWeb.PageController do
  use BetterTogetherWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _) do
    render(conn, "index.html")
  end
end
