[![Travis CI Build Status](https://travis-ci.org/OCannings/tf-idf.svg?branch=master)](https://travis-ci.org/OCannings/tf-idf)

# Tfidf
An Elixir implementation of tf-idf

[Based on the blog post by Steven Loria](http://stevenloria.com/finding-important-words-in-a-document-using-tf-idf/)

## What is tf-idf?
> tf–idf, short for term frequency–inverse document frequency, is a numerical statistic that is intended to reflect how important a word is to a document in a collection or corpus. It is often used as a weighting factor in information retrieval and text mining.

[tf-idf on Wikipedia](https://en.wikipedia.org/wiki/Tf%E2%80%93idf)

## Installation
```elixir
defp deps do
  [{:tfidf, "~> 0.1.0"}]
end
```

## Usage

### Tfidf.calculate(word, text, corpus, tokenize_fn \\\ &tokenize(&1))
 Calculates the tf-idf for a given word within a text and a corpus (List) of
  texts.
```elixir
iex> Tfidf.calculate("dog", "nice dog dog", ["dog hat", "dog", "cat mat", "duck"])
0.19178804830118723
```
  An optional tokenizer function can be passed as the last argument to replace the default tokenizer:
```elixir
iex> Tfidf.calculate("dog", "nice,dog,dog", ["dog,hat", "dog", "cat,mat", "duck"], &String.split(&1, ","))
0.19178804830118723
```

___

### Tfidf.calculate(word, tokenized_text, corpus)
  Calculates the tf-idf for a given word within a pre-tokenized list and a corpus
  comprised of pre-tokenized lists.
  
```elixir
iex> Tfidf.calculate("dog", ["nice", "dog", "dog"], [["dog", "hat"], ["dog"], ["cat", "mat"], ["duck"]])
0.19178804830118723
```

___

### Tfidf.calculate_all(text, corpus, tokenize_fn \\\ &tokenize(&1)) 
 Calculates the tf-idf for all words in a given text, returns a list
  of {word, score} tuples.

```elixir
iex> Tfidf.calculate_all("nice dog", ["dog hat", "dog", "cat mat", "duck"])
[{"nice", 0.6931471805599453}, {"dog", 0.14384103622589042}]
```

  As with `Tfidf.calculate/4` an optional tokenizer function can be passed
  as the last argument. This will be used in place of the default tokenizer.
  
```elixir
iex> Tfidf.calculate_all("nice,dog", ["dog,hat", "dog", "cat,mat", "duck"], &String.split(&1, ","))
[{"nice", 0.6931471805599453}, {"dog", 0.14384103622589042}]
```
