defmodule Broker.MixProject do
  use Mix.Project

  def project do
    [
      app: :rtp,
      version: "0.0.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Rtp.Application, []}
    ]
  end

  def deps do
    [
      {:eventsource_ex, git: "git://github.com/cwc/eventsource_ex.git"},
      {:mongodb_driver, git: "git://github.com/zookzook/elixir-mongodb-driver.git"},
      {:json, "~> 1.4"}
    ]
  end
end