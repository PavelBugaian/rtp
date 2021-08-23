defmodule Transmitter.Worker do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle(data, subscriber) do
    content = case serialize(data) do
      {:ok, content} -> handle_success(content)
      {:error, error} -> handle_error(error)
    end

    Server.write_line(subscriber, {:for_subscriber, content})

    content
  end

  defp serialize(data) do
    case JSON.decode(data) do
      {:ok, content} -> {:ok, content}
      {:error, error} -> handle_error(error)
    end
  end

  defp handle_success(content) do
    content["message"]["tweet"]["text"]
  end

  defp handle_error(error) do
    Logger.debug "#{error}"

    {:error, error}
  end
end
