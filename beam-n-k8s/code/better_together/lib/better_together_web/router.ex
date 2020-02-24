defmodule BetterTogetherWeb.Router do
  use BetterTogetherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", BetterTogetherWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/prime_calculators", PrimeCalculatorController
  end
end
