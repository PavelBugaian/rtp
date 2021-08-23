defmodule Transmitter.Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle(data) do
    case serialize(data) do
      {:ok, content} -> handle_success(content)
      {:error} -> handle_error()
    end
  end

  defp serialize(data) do
    case JSON.decode(data) do
      {:ok, content} -> {:ok, content}
      {:error, _} -> handle_error()
    end
  end

  defp handle_success(content) do
    content["message"]["tweet"]["text"]
  end

  defp handle_error() do
    {:error}
  end
end
