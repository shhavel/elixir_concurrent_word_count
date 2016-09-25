# Usage:
#
#     iex async_word_count.exs
#

start_time = :os.system_time(:milli_seconds)

word_count = fn(file, word) ->
  :timer.sleep(1000)
  {:ok, content} = File.read(file)
  count = length(String.split(content, word)) - 1
  IO.puts "Found #{inspect count} occurrence(s) of the word in file #{inspect file}"
  count
end

async_word_count = fn(file, word) ->
  caller = self
  spawn(fn ->
    send(caller, {:result, word_count.(file, word)})
  end)
end

get_result = fn ->
  receive do
    {:result, result} -> result
  end
end

Path.wildcard("/Users/alex/Scripts/elixir_concurrent_word_count/OGENRI/*.txt")
|> Enum.map(fn(file) -> async_word_count.(file, "лошадь") end)
|> Enum.map(fn(_) -> get_result.() end)
|> Enum.reduce(fn(x, acc) -> acc + x end)
|> IO.puts

end_time = :os.system_time(:milli_seconds)
IO.puts "Finished in #{(end_time - start_time) / 1000} seconds"
