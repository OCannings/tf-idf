defmodule Tfidf do
  def calculate(word, text, corpus) do
    text = tokenize(text)
    corpus = Enum.map(corpus, &tokenize(&1))

    tf(word, text) * idf(word, corpus)
  end

  def calculate_all(text, corpus) do
    Enum.map(tokenize(text) |> Enum.uniq, fn(word) ->
      %{:score => calculate(word, text, corpus), :word => word}
    end)
  end

  def word_count(word, text) do
    Enum.reduce(text, 0, fn(cur_word, acc) ->
      cur_word == word && (acc + 1) || acc
    end)
  end

  @doc """
  Splits a string into a tokenized list.

  ## Tfidf.tokenize("Doctor Who") == ["doctor", "who"]
  """
  def tokenize(text), do: String.downcase(text) |> String.split(" ")

  defp tf(word, text) do
    word_count(word, text) / length(text)
  end

  defp n_containing(word, corpus) do
    Enum.reduce(corpus, 0, fn(text, acc) ->
      index = Enum.find_index(text, fn(cur_word) -> word == cur_word end)
      unless is_nil(index), do: acc + 1, else: acc
    end)
  end

  defp idf(word, corpus) do
    :math.log(length(corpus) / (1 + n_containing(word, corpus)))
  end

end
