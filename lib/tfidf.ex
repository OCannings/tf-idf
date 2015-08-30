defmodule Tfidf do
  @moduledoc """
  **Term frequency-inverse document frequency**

  From Wikipedia:

      tf–idf, short for term frequency–inverse document frequency, is a numerical
      statistic that is intended to reflect how important a word is to a document
      in a collection or corpus. It is often used as a weighting factor in
      information retrieval and text mining.

  Based on the blog post by Steven Loria:
  http://stevenloria.com/finding-important-words-in-a-document-using-tf-idf/

  **Basic Usage**

      iex> Tfidf.calculate("dog", "nice dog dog", ["dog hat", "dog", "cat mat", "duck"])
      0.19178804830118723
  """

  @doc """
  Calculates the tf-idf for a given word within a tokenized list and a corpus
  comprised of tokenized lists.

      iex> Tfidf.calculate("dog", ["nice", "dog", "dog"], [["dog", "hat"], ["dog"], ["cat", "mat"], ["duck"]])
      0.19178804830118723

  """
  def calculate(word, tokenized_text, corpus) when is_list(tokenized_text) do
    tfidf(word, tokenized_text, corpus)
  end

  @doc """
  Calculates the tf-idf for a given word within a text and a corpus (List) of
  texts.

      iex> Tfidf.calculate("dog", "nice dog dog", ["dog hat", "dog", "cat mat", "duck"])
      0.19178804830118723

  `calculate/4` is a BYOT function (bring your own tokenizer). An optional tokenizer
  function can be passed as the last argument to replace the default tokenizer:

      iex> Tfidf.calculate("dog", "nice,dog,dog", ["dog,hat", "dog", "cat,mat", "duck"], &String.split(&1, ","))
      0.19178804830118723

  """
  def calculate(word, text, corpus, tokenize_fn \\ &tokenize(&1)) do
    text = tokenize_fn.(text)
    corpus = Enum.map(corpus, tokenize_fn)

    tfidf(word, text, corpus)
  end

  @doc """
  Calculates the tf-idf for all words in a given text, returns a list
  of {word, score} tuples.

      iex> Tfidf.calculate_all("nice dog", ["dog hat", "dog", "cat mat", "duck"])
      [{"nice", 0.6931471805599453}, {"dog", 0.14384103622589042}]

  As with `Tfidf.calculate/4` an optional tokenizer function can be passed
  as the last argument. This will be used in place of the default tokenizer.

      iex> Tfidf.calculate_all("nice,dog", ["dog,hat", "dog", "cat,mat", "duck"], &String.split(&1, ","))
      [{"nice", 0.6931471805599453}, {"dog", 0.14384103622589042}]
  """
  def calculate_all(text, corpus, tokenize_fn \\ &tokenize(&1)) do
    Enum.map(tokenize_fn.(text) |> Enum.uniq, fn(word) ->
      {word, calculate(word, text, corpus, tokenize_fn)}
    end)
  end

  @doc """
  Returns the number of times a word appears in a given text

      iex> Tfidf.word_count("dog", "cat dog cat dog")
      2
  """
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
