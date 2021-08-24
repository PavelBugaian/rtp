defmodule Transmitter.ConnectionItem do
  use Agent
  require Logger

  def start_link(opts) do
    {url, subscriber} = parse_options(opts)
    EventsourceEx.new(url, stream_to: self())
    recv(subscriber)
  end

  def drop_connection() do
    Agent.stop(:shutdown)
  end

  defp parse_options(opts) do
    url = opts[:url]
    subscriber = opts[:subscriber]

    {url, subscriber}
  end

  defp recv(subscriber) do
    receive do
      tweet ->
        Transmitter.Counter.log_request()
        Transmitter.WorkerService.route(tweet.data, subscriber)
    end
    recv(subscriber)
  end
end
