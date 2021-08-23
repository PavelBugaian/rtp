defmodule ScoreAnalyzer do
  def get_score(message) do
    words_list = String.split(message, ~r/[\s.!?:;]{1,}/, trim: true)
    words_count = Enum.count(words_list)

    case words_count do
      0 -> 0
      _wildcard -> (Enum.map(words_list, &Model.Sentiments.get(&1)) |> Enum.sum()) / words_count
    end
  end
end
