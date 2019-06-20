defmodule Pohmeedor.TimerStubs do

  def random_timers(count) do
    Enum.map(0..count - 1, &random_timer/1)
  end

  def with_name(timers, name) do
    Enum.map(timers, fn timer -> %{timer | "name" => name} end)
  end

  defp random_timer(_) do
    %{
      "id" => Ecto.UUID.generate(),
      "duration" => Enum.random(0..10_000),
      "name" => random_name()
    }
  end

  def random_name() do
    Ecto.UUID.generate()
    |> Base.url_encode64
    |> binary_part(0, 5)
  end

  def stringify_keys(map) do
    for {key, val} <- map, into: %{}, do: {Atom.to_string(key), val}
  end
end
