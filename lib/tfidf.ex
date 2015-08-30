defmodule Tfidf do
  def calculate(word, text, corpus) when is_list(text) do
    tfidf(word, text, corpus)
  end

  def calculate(word, text, corpus, tokenize_fn \\ &tokenize(&1)) do
    text = tokenize_fn.(text)
    corpus = Enum.map(corpus, tokenize_fn)

    tfidf(word, text, corpus)
  end

  def calculate_all(text, corpus, tokenize_fn \\ &tokenize(&1)) do
    Enum.map(tokenize_fn.(text) |> Enum.uniq, fn(word) ->
      {word, calculate(word, text, corpus, tokenize_fn)}
    end)
  end

  def word_count(word, text) do
    Enum.reduce(text, 0, fn(cur_word, acc) ->
      if cur_word == word, do: acc + 1, else: acc
    end)
  end

  @doc """
  Splits a string into a tokenized list.

  ## Tfidf.tokenize("Doctor Who") == ["Doctor", "Who"]
  """
  def tokenize(text) do
    String.split(text, " ")
    |> Enum.filter(fn x -> x != "" end) # remove empty elements
  end

  defp tfidf(word, text, corpus) do
    tf(word, text) * idf(word, corpus)
  end

  defp tf(word, text) do
    word_count(word, text) / length(text)
  end

  defp n_containing(word, corpus) do
    Enum.reduce(corpus, 0, fn(text, acc) ->
      if list_contains(text, word), do: acc + 1, else: acc
    end)
  end

  defp list_contains(list, item) do
    Enum.find_index(list, fn cur_item -> item == cur_item end) != nil
  end

  defp idf(word, corpus) do
    :math.log(length(corpus) / (1 + n_containing(word, corpus)))
  end
end
