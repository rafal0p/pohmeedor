defmodule Pohmeedor.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Pohmeedor.Repo

  alias Pohmeedor.Core.Timer

  @doc """
  Returns the list of timers.

  ## Examples

      iex> list_timers()
      [%Timer{}, ...]

  """
  def list_timers(now \\ DateTime.utc_now()) do
    Repo.all(Timer)
    |> Enum.map(&(add_completed_percentage(&1, now)))
  end

  def list_timers_by_name(name, now \\ DateTime.utc_now()) do
    Timer
    |> where([timer], timer.name == ^name)
    |> Repo.all()
    |> Enum.map(&(add_completed_percentage(&1, now)))
  end

  @doc """
  Gets a single timer.

  Raises `Ecto.NoResultsError` if the Timer does not exist.

  ## Examples

      iex> get_timer!(123)
      %Timer{}

      iex> get_timer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timer!(id, now \\ DateTime.utc_now()) do
    Repo.get!(Timer, id)
    |> add_completed_percentage(now)
  end

  defp add_completed_percentage(timer, now) do
    Map.put(timer, :completed_percentage, completion_of(timer, now))
  end

  defp completion_of(timer, now) do
    completed_millis = DateTime.diff(now, timer.start_time, :millisecond)
    completed_percentage = completed_millis / timer.duration
    cap(completed_percentage, 0, 1)
  end

  defp cap(n, min, max) do
    cond do
      n < min -> min
      n > max -> max
      true -> n
    end
  end

  @doc """
  Creates a timer.

  ## Examples

      iex> create_timer(%{field: value})
      {:ok, %Timer{}}

      iex> create_timer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timer(attrs, now \\ DateTime.utc_now()) do
    attrs = Map.put(attrs, "start_time", now)
    %Timer{}
    |> Timer.changeset(attrs)
    |> Repo.insert()
  end
end
