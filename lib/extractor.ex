defmodule Extractor do
  @doc """
  	iex> Extractor.get(%{state: %{a: [b: 1, c: 2]}}, [:b, :a])  

  	[a: [b: 1, c: 2], b: 1]

  """
  def get(enum, keys) when (is_list(keys) and is_map(enum)) or is_list(enum) do
    Enum.reduce(keys, [], &get(enum, &1, &2))
  end

  @doc false
  def get({key, _} = set, key2, acc) when key == key2, do: [set | acc]

  def get({_, value}, key, acc) when is_map(value) or is_list(value) do
    get(value, key, acc)
  end

  def get(enum, {key, sub_keys}, acc)
      when is_map(enum) or (is_list(enum) and is_list(sub_keys)) do
    [{key, get(enum, key, []) |> get(sub_keys)} | acc]
  end

  def get(enum, key, acc) when is_map(enum) or is_list(enum) do
    Enum.reduce(enum, acc, &get(&1, key, &2))
  end

  def get({_, _}, _, acc), do: acc
end
