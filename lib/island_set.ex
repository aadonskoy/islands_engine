defmodule IslandsEngine.IslandSet do
  alias IslandsEngine.{Island, IslandSet}

  defstruct atoll: :none, dot: :none, l_shape: :none, s_shape: :none, square: :none

  def start_link() do
    Agent.start_link(fn -> initialized_set() end)
  end

  def initialized_set() do
    Enum.reduce(keys(), %IslandSet{}, fn key, set ->
      {:ok, island} = Island.start_link
      Map.put(set, key, island)
    end)
  end

  def keys() do
    %IslandSet{}
    |> Map.from_struct
    |> Map.keys
  end

  def to_string(set) do
    "%IslandSet{" <> string_body(set) <> "}"
  end

  def string_body(set) do
    Enum.reduce(keys(), "", fn key, acc ->
      island = Agent.get(set, &(Map.fetch!(&1, key)))
      acc <> "#{key} => #{Island.to_string(island)}" <> "\n"
    end)
  end
end
