# Usage:
#
#     iex sync_word_count.exs
#

start_time = :os.system_time(:milli_seconds)

word_count = fn(file, word) ->
  :timer.sleep(1000)
  {:ok, content} = File.read(file)
  count = length(String.split(content, word)) - 1
  IO.puts "Found #{inspect count} occurrence(s) of the word in file #{inspect file}"
  count
end

Path.wildcard("/Users/alex/Scripts/elixir_concurrent_word_count/OGENRI/*.txt")
|> Enum.map(fn(file) -> word_count.(file, "лошадь") end)
|> Enum.reduce(fn(x, acc) -> acc + x end)
|> IO.puts

end_time = :os.system_time(:milli_seconds)
IO.puts "Finished in #{(end_time - start_time) / 1000} seconds"
