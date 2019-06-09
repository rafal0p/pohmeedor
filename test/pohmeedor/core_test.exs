defmodule Pohmeedor.CoreTest do
  use Pohmeedor.DataCase

  alias Pohmeedor.Core

  describe "timers" do
    alias Pohmeedor.Core.Timer

    @valid_attrs %{
      "id" => Ecto.UUID.generate,
      "duration" => 42,
      "name" => "some name"
    }
    @invalid_attrs %{"id" => nil, "duration" => nil, "name" => nil}

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
      now = DateTime.utc_now()
      assert {:ok, %Timer{} = timer} = Core.create_timer(@valid_attrs, now)
      assert timer.id == @valid_attrs["id"]
      assert timer.duration == @valid_attrs["duration"]
      assert timer.name == @valid_attrs["name"]
      assert timer.start_time == now
    end

    test "create_timer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_timer(@invalid_attrs)
    end

    test "create_time/1 twice with the same id" do
      Core.create_timer(@valid_attrs)

      assert {:error, changeset} = Core.create_timer(@valid_attrs)
      {_, [constraint: constraint, constraint_name: _]} = changeset.errors[:id]
      assert constraint == :unique
    end
  end
end
