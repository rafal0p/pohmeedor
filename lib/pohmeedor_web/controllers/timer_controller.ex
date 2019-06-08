defmodule PohmeedorWeb.TimerController do
  use PohmeedorWeb, :controller

  alias Pohmeedor.Core
  alias Pohmeedor.Core.Timer

  action_fallback PohmeedorWeb.FallbackController

  def index(conn, _params) do
    timers = Core.list_timers()
    render(conn, "index.json", timers: timers)
  end

  def create(conn, %{"timer" => timer_params}) do
    timer_params = Map.put(timer_params, "id", Ecto.UUID.generate())
    with {:ok, %Timer{} = timer} <- Core.create_timer(timer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.timer_path(conn, :show, timer))
      |> render("show.json", timer: timer)
    end
  end

  def show(conn, %{"id" => id}) do
    timer = Core.get_timer!(id)
    render(conn, "show.json", timer: timer)
  end
end
