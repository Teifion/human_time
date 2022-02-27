defmodule HumanTime.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :human_time,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      package: package(),
      dialyzer: dialyzer(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp description do
    """
    Human Time is a function to convert a string such as "every other tuesday", "every weekday" or "every friday at 2pm" and convert it into a sequence of date times as allowed by the string.
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :timex]
    ]
  end

  defp docs do
    [
      # main: "getting-started",
      main: "HumanTime",
      formatter_opts: [gfm: true],
      source_ref: @version,
      source_url: "https://github.com/teifion/human_time",
      extras: []
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Teifion Jordan"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://github.com/teifion/human_time/blob/master/CHANGELOG.md",
        GitHub: "https://github.com/teifion/human_time"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.7.6"},
      {:excoveralls, "~> 0.14.4", only: :test},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.28.2", only: :dev, runtime: false},
      {:credo, "~> 1.6.3", only: [:dev, :test]}
    ]
  end
end
