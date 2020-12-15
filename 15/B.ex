spoken = File.read!("input.txt")
         |> String.trim
         |> String.split(",")
         |> Stream.map(&String.to_integer/1)
         |> Stream.with_index
         |> Stream.map(fn ({c, i}) -> {c, [i + 1]} end)
         |> Map.new

[[iLast], vLast] = (fn maxTurn -> [maxTurn, Enum.find(spoken, fn {_, v} -> v == maxTurn end) |> elem(0)] end).(Enum.max(Map.values(spoken)))

[_spoken, vLast, _] = Enum.reduce((iLast + 1)..30000000, [spoken, vLast, true], fn turn, acc ->
  [hist, last, wasLastFirst] = acc
  newVal = if wasLastFirst, do: 0, else: (
    [p1, p2] = Enum.take(Map.get(hist, last), -2)
    p2 - p1)
  [
    if Map.has_key?(hist, newVal) do
      Map.put(hist, newVal, Enum.take(Map.get(hist, newVal), -1) ++ [turn])
    else
      Map.put(hist, newVal, [turn])
    end,
    newVal,
    !Map.has_key?(hist, newVal)
  ]
end)

IO.puts(vLast)