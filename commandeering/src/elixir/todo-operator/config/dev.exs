use Mix.Config

config :logger, level: :debug

config :k8s,
  clusters: %{
    default: %{
      conn: "~/.kube/config"
    }
  }
