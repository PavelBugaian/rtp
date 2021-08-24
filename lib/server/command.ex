defmodule Server.Command do
  require Logger

  def parse(line) do
    case String.split(line, " ", parts: 3) |> Enum.map(fn string -> String.trim(string) end) do
      ["PUBLISH", topic, data] -> {:ok, {:publish, topic, data}}
      ["SUBSCRIBE", topic] -> {:ok, {:subscribe, topic}}
      ["UNSUBSCRIBE", topic] -> {:ok, {:unsubscribe, topic}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(command, socket)

  def run({:publish, topic, data}, socket) do
    subscriber_list = Server.PubSubController.get_subscribers_by_topic(topic)

    Enum.each(subscriber_list, fn subscriber -> Server.write_line(subscriber.subscriber, {:for_subscriber, data}) end)
    {:ok, "Successfully published #{data}\r\n"}
  end

  def run({:subscribe, topic}, socket) do
    Server.PubSubController.add_subscriber(topic, socket)

    {:ok, "Successfully subscribed to #{topic}\r\n"}
  end

  def run({:unsubscribe, topic}, socket) do
    Server.PubSubController.delete_subscriber(topic, socket)

    {:ok, "Successfully unsubscribed from #{topic}\r\n"}
  end

end
