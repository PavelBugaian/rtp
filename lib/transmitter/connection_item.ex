defmodule Transmitter.ConnectionItem do
  use Agent
  require Logger

  def start_link(opts) do

    Logger.info "Transmitter.ConnectionItem start_link"

    {url} = parse_options(opts)
    EventsourceEx.new(url, stream_to: self())
    recv()
  end

  defp parse_options(opts) do
    url = opts[:url]
    {url}
  end

  defp recv() do
    receive do
      tweet ->
        Logger.info "#{tweet.data}"
        Transmitter.Worker.handle(tweet.data)
    end
    recv()
  end
end
