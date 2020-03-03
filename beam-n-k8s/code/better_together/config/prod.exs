use Mix.Config

config :better_together, BetterTogetherWeb.Endpoint,
  url: [
    # host: "example.com", 
    port: 80
  ],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :libcluster,
  topologies: [
    k8s: [
      strategy: Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "better-together-headless",
        application_name: "better_together",
        polling_interval: 10_000
      ]
    ]
  ]

import_config "prod.secret.exs"
