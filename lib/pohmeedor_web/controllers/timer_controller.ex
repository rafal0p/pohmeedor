defmodule PohmeedorWeb.TimerController do
  use PohmeedorWeb, :controller

  alias Pohmeedor.Core

  action_fallback PohmeedorWeb.FallbackController

  def index(conn, _params) do
    timers = Core.list_timers()
    render(conn, "index.json", timers: timers)
  end

  def create(conn, %{"timer" => timer_params}) do
    with {:ok, _} <- Core.create_timer(timer_params, DateTime.utc_now()) do
      conn
      |> send_resp(:created, "")
    end
  end

  def show(conn, %{"id" => id}) do
    timer = Core.get_timer!(id)
    render(conn, "show.json", timer: timer)
  end
end
