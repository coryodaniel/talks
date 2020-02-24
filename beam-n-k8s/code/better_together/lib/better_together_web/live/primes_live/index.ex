defmodule BetterTogetherWeb.PrimesLive.Index do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, fetch(socket)}
  end

  def render(assigns),
    do: Phoenix.View.render(BetterTogetherWeb.PrimesView, "index.html", assigns)

  def handle_event("calc_primes", _value, socket) do
    # do the deploy process
    {:noreply, assign(socket, primes: "list-of-primes-here")}
  end

  # def render(assigns), do: UserView.render("index.html", assigns)

  defp fetch(socket) do
    assign(socket, primes: [])
  end

  # def handle_event("delete_user", id, socket) do
  #   user = Accounts.get_user!(id)
  #   {:ok, _user} = Accounts.delete_user(user)
  #   {:noreply, fetch(socket) }
  # end
end
