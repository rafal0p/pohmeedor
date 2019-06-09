defmodule PohmeedorWeb.TimerControllerTest do
  use PohmeedorWeb.ConnCase

  alias Pohmeedor.Core

  @create_attrs %{
    id: Ecto.UUID.generate(),
    duration: 42,
    name: "some name"
  }
  @invalid_attrs %{id: nil, duration: nil, name: nil}

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
      assert "" == response(conn, 201)

      conn = get(conn, Routes.timer_path(conn, :show, @create_attrs.id))

      assert %{
               "id" => id,
               "duration" => duration,
               "name" => name,
               "start_time" => start_time
             } = json_response(conn, 200)["data"]
      {:ok, start_time, _utc_offset} = DateTime.from_iso8601(start_time)

      assert id == @create_attrs.id
      assert duration == @create_attrs.duration
      assert name == @create_attrs.name
      assert DateTime.diff(DateTime.utc_now(), start_time, :second) < 2
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.timer_path(conn, :create), timer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "create with existing id", %{conn: conn} do
      post(conn, Routes.timer_path(conn, :create), timer: @create_attrs)

      conn = post(conn, Routes.timer_path(conn, :create), timer: @create_attrs)

      assert %{
               "errors" => %{
                 "id" => ["has already been taken"]
               }
             } == json_response(conn, 422)
    end
  end
end
