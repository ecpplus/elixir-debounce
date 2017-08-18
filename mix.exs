defmodule DBounce.Mixfile do
  use Mix.Project

  def project do
    [
      app: :d_bounce,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "DBounce",
      source_url: "https://github.com/ecpplus/elixir-d-bounce"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Elixir d-bounce.
    """
  end

  defp package do
    [
      name: :d_bounce,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["chu"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ecpplus/elixir-d-bounce"}
    ]
  end
end
