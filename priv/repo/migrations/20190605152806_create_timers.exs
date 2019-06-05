defmodule Pohmeedor.Repo.Migrations.CreateTimers do
  use Ecto.Migration

  def change do
    create table(:timers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start_time, :naive_datetime_usec
      add :duration, :integer
      add :name, :string
    end

  end
end
