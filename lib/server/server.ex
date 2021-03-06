defmodule Server do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info "Server can now accept connections to #{port}"

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(
      Server.TaskSupervisor,
      fn -> serve(client) end
    )

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    {:ok, data} = read_line(socket)
    {:ok, command} = Server.Command.parse(data)

    msg = Server.Command.run(command, socket)

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  def write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  def write_line(socket, {:for_subscriber, text}) do
    :gen_tcp.send(socket, text <> "\r\n")
  end

  def write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  def write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  def write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
