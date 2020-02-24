defmodule BetterTogetherWeb.PrimeCalculatorController do
  use BetterTogetherWeb, :controller

  alias BetterTogether.PrimeCalculators

  def index(conn, _params) do
    prime_calculators = PrimeCalculators.list_prime_calculators()
    render(conn, "index.html", prime_calculators: prime_calculators)
  end

  def new(conn, _params) do
    render(conn, "new.html", conn: conn)
  end

  def create(conn, %{"limit" => limit}) do
    case PrimeCalculators.create_prime_calculator(limit) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Prime calculator started.")
        |> redirect(to: Routes.prime_calculator_path(conn, :index))

      _error ->
        render(conn, "new.html", conn: conn)
    end
  end
end
