defmodule Pohmeedor.Repo.Migrations.CreateTimers do
  use Ecto.Migration

  def change do
    create table(:timers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_time, :utc_datetime_usec, null: false
      add :duration, :integer, null: false
      add :name, :string
    end

  end
end
