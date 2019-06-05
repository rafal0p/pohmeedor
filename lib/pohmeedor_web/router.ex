defmodule PohmeedorWeb.Router do
  use PohmeedorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PohmeedorWeb do
    pipe_through :api

    get "/timers/:id", TimerController, :show
    post "/timers", TimerController, :create
  end
end
