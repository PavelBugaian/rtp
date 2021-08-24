defmodule Rtp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Supervisor.child_spec({Task, fn -> Server.PubSubController.start end}, id: Registry),
      {Task.Supervisor, name: Server.TaskSupervisor},
      {DynamicSupervisor, name: ConnectionSupervisor, strategy: :one_for_one},
      {Transmitter.WorkerService, name: Transmitter.WorkerService},
      {Transmitter.Counter, name: Transmitter.Counter},
      {Transmitter.Autoscaler, name: Transmitter.Autoscaler},
      {DynamicSupervisor, name: WorkerDynamicSupervisor, strategy: :one_for_one},
      Supervisor.child_spec({Task, fn -> Server.accept(6666) end}, id: Server),
      {Transmitter.WorkerSupervisor, name: Transmitter.WorkerSupervisor},
      {SentimentsDatabase, name: SentimentsDatabase},
      {TweetService, name: TweetService},
    ]

    opts = [strategy: :one_for_one, name: Server.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
