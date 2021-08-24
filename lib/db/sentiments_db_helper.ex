defmodule SentimentsDatabase do
  use GenServer
  require Logger

  def post_tweets(tweets) do
    GenServer.cast(__MODULE__, {:post_tweets, tweets})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    {:ok, connection} = Mongo.start_link(database: "rtp", url: "mongodb://localhost:27017")
  end

  @impl true
  def handle_cast({:post_tweets, tweets}, connection) do
    Mongo.insert_many(connection, "tweets", tweets)

    {:noreply, connection}
  end
end
