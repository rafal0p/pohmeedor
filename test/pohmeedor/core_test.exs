defmodule Pohmeedor.CoreTest do
  use Pohmeedor.DataCase

  alias Pohmeedor.Core

  describe "timers" do
    alias Pohmeedor.Core.Timer

    @valid_attrs %{duration: 42, name: "some name", start_time: ~N[2010-04-17 14:00:00.000000]}
    @invalid_attrs %{duration: nil, name: nil, start_time: nil}

    def timer_fixture(attrs \\ %{}) do
      {:ok, timer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_timer()

      timer
    end

    test "list_timers/0 returns all timers" do
      timer = timer_fixture()
      assert Core.list_timers() == [timer]
    end

    test "get_timer!/1 returns the timer with given id" do
      timer = timer_fixture()
      assert Core.get_timer!(timer.id) == timer
    end

    test "create_timer/1 with valid data creates a timer" do
      assert {:ok, %Timer{} = timer} = Core.create_timer(@valid_attrs)
      assert timer.duration == 42
      assert timer.name == "some name"
      assert timer.start_time == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_timer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_timer(@invalid_attrs)
    end
  end
end
