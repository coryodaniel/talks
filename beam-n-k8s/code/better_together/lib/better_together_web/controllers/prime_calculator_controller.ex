defmodule BetterTogetherWeb.PrimeCalculatorController do
  use BetterTogetherWeb, :controller

  alias BetterTogether.PrimeCalculators
  alias BetterTogether.PrimeCalculators.PrimeCalculator

  def index(conn, _params) do
    prime_calculators = PrimeCalculators.list_prime_calculators()
    render(conn, "index.html", prime_calculators: prime_calculators)
  end

  def new(conn, _params) do
    #changeset = PrimeCalculators.change_prime_calculator(%PrimeCalculator{})
    #changeset = %{}
    render(conn, "new.html", conn: conn)
  end

  def create(conn, %{"limit" => limit}) do
    case PrimeCalculators.create_prime_calculator(limit) do
      {:ok, prime_calculator} ->
        conn
        |> put_flash(:info, "Prime calculator started.")
        |> redirect(to: Routes.prime_calculator_path(conn, :index))

      _error ->
      #{:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", conn: conn)
    end
  end
end
