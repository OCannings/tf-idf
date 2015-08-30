defmodule TfidfTest do
  use ExUnit.Case, async: true

  setup_all do
    corpus = Enum.map([1,2,3], fn(i) ->
      {:ok, file} = File.read("test/fixtures/document-#{i}.txt")
      file |> String.replace("\n", "")
    end)

    comma_corpus = Enum.map([1,2,3], fn(i) ->
      {:ok, file} = File.read("test/fixtures/document-#{i}-comma.txt")
      file |> String.replace("\n", "")
    end)

    {:ok,
      corpus: corpus,
      text: corpus |> List.first,
      comma_text: comma_corpus |> List.first,
      comma_corpus: comma_corpus,
      scores: %{
        films: 0.00997,
        film: 0.00665,
        California: 0.00665
      }
    }
  end

  test "word_count/2" do
    assert Tfidf.word_count("apple", ["banana"]) == 0
    assert Tfidf.word_count("apple", ["apple", "banana"]) == 1
    assert Tfidf.word_count("apple", ["apple", "banana", "apple"]) == 2
  end

  test "calculate/3 (pre-tokenized)" do
    pre_tokenized = Tfidf.calculate("a", ["a", "cat"], [["a", "monkey"], ["a", "dog"]])
    auto_tokenized = Tfidf.calculate("a", "a cat", ["a monkey", "a dog"])

    assert pre_tokenized == auto_tokenized
  end

  test "calculate/4", context do
    tfidf = fn(word) ->
      Tfidf.calculate(word, context[:text], context[:corpus], &String.split(&1, " "))
      |> Float.round(5)
    end

    assert tfidf.("films") == context[:scores][:films]
    assert tfidf.("film") == context[:scores][:film]
    assert tfidf.("California") == context[:scores][:California]
  end

  test "calculate/4 (default tokenizer)" do
    default_tokenize = Tfidf.calculate("a", "a cat", ["a monkey", "a dog"])
    explicit_default_tokenize = Tfidf.calculate("a", "a cat", ["a monkey", "a dog"], &Tfidf.tokenize(&1))

    assert default_tokenize == explicit_default_tokenize
  end

  test "calculate/4 (custom tokenizer)", context do
    default_tokenize = Tfidf.calculate("films", context[:text], context[:corpus])
    custom_tokenize = Tfidf.calculate("films", context[:comma_text], context[:comma_corpus], &String.split(&1, ","))

    assert default_tokenize == custom_tokenize
  end

  test "calculate_all/3", context do
    scores = Tfidf.calculate_all(context[:text], context[:corpus])

    films_score = Enum.find(scores, fn(x) -> x[:word] == "films" end)[:score]
    film_score = Enum.find(scores, fn(x) -> x[:word] == "film" end)[:score]
    california_score = Enum.find(scores, fn(x) -> x[:word] == "California" end)[:score]

    assert films_score == Tfidf.calculate("films", context[:text], context[:corpus])
    assert film_score == Tfidf.calculate("film", context[:text], context[:corpus])
    assert california_score == Tfidf.calculate("California", context[:text], context[:corpus])
  end

  test "calculate_all/3 (custom tokenizer)", context do
    default_scores = Tfidf.calculate_all(
      context[:text],
      context[:corpus]
    )

    custom_scores = Tfidf.calculate_all(
      context[:comma_text],
      context[:comma_corpus],
      &String.split(&1, ",")
    )

    assert default_scores == custom_scores
  end

  test "tokenize/1" do
    assert Tfidf.tokenize("") == []
    assert Tfidf.tokenize("Batman") == ["Batman"]
    assert Tfidf.tokenize("Doctor Who") == ["Doctor", "Who"]
  end
end
