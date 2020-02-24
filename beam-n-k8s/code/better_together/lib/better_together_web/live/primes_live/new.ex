defmodule BetterTogetherWeb.PrimesLive.New do
  use Phoenix.LiveView

  alias BetterTogetherWeb.PrimesLive
  alias BetterTogetherWeb.Router.Helpers, as: Routes

  def mount(_params, _session, socket) do
    {:ok, assign(socket, [])}
  end

  def render(assigns), do: Phoenix.View.render(BetterTogetherWeb.PrimesView, "new.html", assigns)

  def handle_event("save", %{"primes" => %{"limit" => limit}} = params, socket) do
    case start_calculator(limit) do
      {:ok, pid} ->
        {:noreply,
         socket
         |> put_flash(:info, "calculator started")
         |> redirect(to: Routes.live_path(socket, PrimesLive.Index))}

      _error ->
        {:noreply, assign(socket, [])}
    end
  end

  defp start_calculator(limit) do
    with {int, _} <- Integer.parse(limit) do
      BetterTogether.PrimeCalculator.start_link(int)
    end
  end
end
