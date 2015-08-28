defmodule TfidfTest do
  use ExUnit.Case

  test "#word_count" do
    assert Tfidf.word_count("apple", ["banana"]) == 0
    assert Tfidf.word_count("apple", ["apple", "banana"]) == 1
    assert Tfidf.word_count("apple", ["apple", "banana", "apple"]) == 2
  end

  test "#calculate()" do
    assert Tfidf.calculate("apple", "apple banana", ["apple pie", "apple poop"]) == 1
  end

  test "#tokenize()" do
    assert Tfidf.tokenize("Doctor Who") == ["doctor", "who"]
  end
end
