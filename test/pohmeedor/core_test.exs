defmodule Pohmeedor.CoreTest do
  use Pohmeedor.DataCase

  alias Pohmeedor.Core
  alias Pohmeedor.Core.Timer
  alias Pohmeedor.TimerStubs

  @valid_attrs %{
    "id" => Ecto.UUID.generate,
    "duration" => 42,
    "name" => "some name"
  }
  @invalid_attrs %{"id" => nil, "duration" => nil, "name" => nil}

  describe "timers creation" do
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

    test "Timer.name is optional" do
      {:ok, %Timer{} = created} = Core.create_timer(Map.delete(@valid_attrs, "name"))

      assert created.id == @valid_attrs["id"]
    end
  end

  describe "timers retrieval" do
    test "list_timers/0 returns all timers" do
      timers_to_persist = TimerStubs.random_timers(5)
                          |> Enum.sort_by(fn %{"id" => id} -> id end)

      Enum.each(timers_to_persist, &(Core.create_timer(&1)))

      Core.list_timers()
      |> Enum.sort_by(&(&1.id))
      |> Enum.zip(timers_to_persist)
      |> Enum.each(
           fn {persisted, to_persist} ->
             assert_timers_equal(persisted, to_persist)
           end
         )
    end

    test "list_timers_by_name/1 filters by name" do
      name = TimerStubs.random_name()
      timers_with_given_name = TimerStubs.random_timers(3)
                               |> TimerStubs.with_name(name)

      Enum.each(
        TimerStubs.random_timers(3) ++
        timers_with_given_name ++
        TimerStubs.random_timers(4),
        &(Core.create_timer(&1))
      )

      filtered_timers = Core.list_timers_by_name(name)
                  |> Enum.map(&(Map.take(&1, [:id, :name, :duration])))
                  |> Enum.map(&(TimerStubs.stringify_keys(&1)))

      Enum.each(timers_with_given_name, fn timer -> assert timer in filtered_timers end)
    end

    test "get_timer!/1 returns the timer with given id" do
      {:ok, %{id: id}} = Core.create_timer(@valid_attrs)
      timer = Core.get_timer!(id)
      assert_timers_equal(timer, @valid_attrs)
    end

    defp assert_timers_equal(timer, map) do
      assert timer.id == map["id"]
      assert timer.duration == map["duration"]
      assert timer.name == map["name"]
      assert timer.start_time.__struct__ == DateTime
      assert timer.completed_percentage >= 0
    end

    for {seconds_to_the_past, duration, percentage} <- [
      {50, 100, 0.5},
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

        {:ok, %{id: id}} = Core.create_timer(
          %{@valid_attrs | "duration" => unquote(duration) * 1000},
          past_timestamp
        )

        timer = Core.get_timer!(id)
        assert_in_delta timer.completed_percentage, unquote(percentage), 0.01
      end
    end
  end
end
