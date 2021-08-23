defmodule Rtp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Supervisor.child_spec({Task, fn -> Server.Registry.start end}, id: Registry),
      {Task.Supervisor, name: Server.TaskSupervisor},
      {DynamicSupervisor, name: ConnectionSupervisor, strategy: :one_for_one},
      Supervisor.child_spec({Task, fn -> Server.accept(6666) end}, id: Server)
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
