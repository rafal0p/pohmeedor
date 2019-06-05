defmodule Pohmeedor.CoreTest do
  use Pohmeedor.DataCase

  alias Pohmeedor.Core

  describe "timers" do
    alias Pohmeedor.Core.Timer

    @valid_attrs %{duration: 42, name: "some name", start_time: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{duration: 43, name: "some updated name", start_time: ~N[2011-05-18 15:01:01.000000]}
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

    test "update_timer/2 with valid data updates the timer" do
      timer = timer_fixture()
      assert {:ok, %Timer{} = timer} = Core.update_timer(timer, @update_attrs)
      assert timer.duration == 43
      assert timer.name == "some updated name"
      assert timer.start_time == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_timer/2 with invalid data returns error changeset" do
      timer = timer_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_timer(timer, @invalid_attrs)
      assert timer == Core.get_timer!(timer.id)
    end

    test "delete_timer/1 deletes the timer" do
      timer = timer_fixture()
      assert {:ok, %Timer{}} = Core.delete_timer(timer)
      assert_raise Ecto.NoResultsError, fn -> Core.get_timer!(timer.id) end
    end

    test "change_timer/1 returns a timer changeset" do
      timer = timer_fixture()
      assert %Ecto.Changeset{} = Core.change_timer(timer)
    end
  end
end
