defmodule Aggregator do
  use GenServer

  def start() do
    {:ok, pid} = Client.start

    GenServer.start_link(__MODULE__, %{tweets: %{}, tcp: pid}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def add(tweet) do
    GenServer.cast(__MODULE__, {:add, tweet})
  end

  @impl true
  def handle_cast({:add, tweet}, state) do
    tweets = add_tweet(tweet, state.tweets)

    Client.send_message(state.tcp, "PUBLISH tweeter " <> Poison.encode!(tweet) <> "\n")

    {:noreply, %{tweets: tweets, tcp: state.tcp}}
  end

  defp add_tweet(element, tweets) do
    id = Map.get(element, :id)

    tweet = Map.get(tweets, id)

    if !tweet do
      Map.put(tweets, id, element)
    else
      sent_score =
        Map.get(tweet, "sentiments_score", Map.get(element, "sent_score", 0.0))

      eng_score =
        Map.get(tweet, "eng_score", Map.get(element, "eng_score", 0.0))

      existing_tweet = Map.put(tweet, "sent_score", sent_score)
      existing_tweet = Map.put(tweet, "eng_score", eng_score)

      Map.put(tweets, existing_tweet["id"], tweet)
    end
  end
end
