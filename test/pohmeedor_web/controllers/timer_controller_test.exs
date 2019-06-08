defmodule PohmeedorWeb.TimerControllerTest do
  use PohmeedorWeb.ConnCase

  alias Pohmeedor.Core

  @create_attrs %{
    id: Ecto.UUID.generate(),
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
      assert conn.status == 201

      conn = get(conn, Routes.timer_path(conn, :show, @create_attrs.id))

      assert %{
               "id" => @create_attrs.id,
               "duration" => @create_attrs.duration,
               "name" => @create_attrs.name,
               "start_time" => NaiveDateTime.to_iso8601(@create_attrs.start_time)
             } == json_response(conn, 200)["data"]
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
