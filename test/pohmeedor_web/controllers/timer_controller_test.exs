defmodule PohmeedorWeb.TimerControllerTest do
  use PohmeedorWeb.ConnCase

  alias Pohmeedor.Core

  @create_attrs %{
    duration: 42,
    name: "some name",
    start_time: ~N[2010-04-17 14:00:00.000000]
  }
  @invalid_attrs %{duration: nil, name: nil, start_time: nil}

  def fixture(:timer) do
    {:ok, timer} = Core.create_timer(@create_attrs)
    timer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timers", %{conn: conn} do
      conn = get(conn, Routes.timer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create timer" do
    test "renders timer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.timer_path(conn, :create), timer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.timer_path(conn, :show, id))

      assert %{
               "id" => id,
               "duration" => 42,
               "name" => "some name",
               "start_time" => "2010-04-17T14:00:00.000000"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.timer_path(conn, :create), timer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
