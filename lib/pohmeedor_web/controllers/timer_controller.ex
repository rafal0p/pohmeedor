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

  def update(conn, %{"id" => id, "timer" => timer_params}) do
    timer = Core.get_timer!(id)

    with {:ok, %Timer{} = timer} <- Core.update_timer(timer, timer_params) do
      render(conn, "show.json", timer: timer)
    end
  end

  def delete(conn, %{"id" => id}) do
    timer = Core.get_timer!(id)

    with {:ok, %Timer{}} <- Core.delete_timer(timer) do
      send_resp(conn, :no_content, "")
    end
  end
end
