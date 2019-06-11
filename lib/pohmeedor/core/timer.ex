defmodule Pohmeedor.Core.Timer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "timers" do
    field :duration, :integer
    field :name, :string
    field :start_time, :utc_datetime_usec
  end

  @doc false
  def changeset(timer, attrs) do
    timer
    |> cast(attrs, [:id, :start_time, :duration, :name])
    |> validate_required([:id, :start_time, :duration])
    |> unique_constraint(:id, name: "timers_pkey")
  end
end
