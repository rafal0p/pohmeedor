defmodule Pohmeedor.Core.Timer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "timers" do
    field :duration, :integer
    field :name, :string
    field :start_time, :naive_datetime_usec
  end

  @doc false
  def changeset(timer, attrs) do
    timer
    |> cast(attrs, [:start_time, :duration, :name])
    |> validate_required([:start_time, :duration, :name])
  end
end
