defmodule TweetService do
  use GenServer

  def tick(count) do
    GenServer.cast(__MODULE__, {:tick, count})
  end

  def add_tweet(tweet) do
    GenServer.cast(__MODULE__, {:post_tweet, tweet})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    tweets = []
    length = 0
    max_length = 128

    {:ok, {tweets, length, max_length}}
  end

  @impl true
  def handle_cast({:tick, count}, {tweets, length, max_length}) do
    new_state = send(tweets, length, max_length)
    {tweets, length, _max_length} = new_state
    {:noreply, {tweets, length, max_length}}
  end

  @impl true
  def handle_cast({:post_tweet, tweet}, {tweets, length, max_length}) do
    tweets = [tweet | tweets]
    length = length + 1

    if (length > max_length) do
      new_state = send(tweets, length, max_length)
      {:noreply, new_state}
    end

    {:noreply, {tweets, length, max_length}}
  end

  def send(tweets, length, max_length) do
    if (length > 0) do
      SentimentsDatabase.post_tweets(tweets)
      {[], 0, max_length}
    end

    {[], 0, max_length}
  end
end
