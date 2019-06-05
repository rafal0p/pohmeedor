defmodule Pohmeedor.Repo do
  use Ecto.Repo,
    otp_app: :pohmeedor,
    adapter: Ecto.Adapters.Postgres
end
