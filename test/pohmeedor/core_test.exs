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
      {:ok, %{id: id}} = Core.create_timer(@valid_attrs)

      timer = Core.get_timer!(id)
      assert timer.id == @valid_attrs["id"]
      assert timer.duration == @valid_attrs["duration"]
      assert timer.name == @valid_attrs["name"]
      assert timer.start_time.__struct__ == DateTime
      assert timer.completed_percentage > 0
    end

    for {seconds_to_the_past, duration, percentage} <- [
      {510, 100, 0.5},
      {0, 100, 0},
      {100, 100, 1},
      {200, 100, 1},
      {-50, 100, 0}
    ] do
      test "get_timer!/1 computes percentage of #{percentage}
      having #{seconds_to_the_past} seconds to the past
      and #{duration} duration" do
        past_timestamp = DateTime.utc_now()
                         |> DateTime.add(-unquote(seconds_to_the_past) * 1000, :millisecond)
        {:ok, %{id: id}} = Core.create_timer(%{@valid_attrs | "duration" => unquote(duration) * 1000}, past_timestamp)

        timer = Core.get_timer!(id)
        assert_in_delta timer.completed_percentage, unquote(percentage), 0.01
      end
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

    test "create_timer/1 twice with the same id" do
      Core.create_timer(@valid_attrs)

      assert {:error, changeset} = Core.create_timer(@valid_attrs)
      {_, [constraint: constraint, constraint_name: _]} = changeset.errors[:id]
      assert constraint == :unique
    end
  end
end
