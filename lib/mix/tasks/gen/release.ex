defmodule Mix.Tasks.Wrap.Gen.Release do
  @moduledoc """
  """

  use Mix.Task

  @template_dir Path.expand("../../../templates", __DIR__)

  @cli_config [
    name: "wrap.gen.release",
    description: "Scaffold a release",
    about: """
    Example:

    mix wrap.gen.release my_release
    """,
    args: [
      release_name: [
        value_name: "RELEASE_NAME",
        help: "wrap release",
        required: true,
        parser: :string
      ]
    ]
  ]

  @shortdoc "Scaffold a release"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = @cli_config |> Optimus.new!() |> Optimus.parse!(argv)

    Mix.Generator.create_directory("packages/releases/#{cli.args.release_name}")

    Mix.Generator.copy_template(
      "#{@template_dir}/release/config.exs.template",
      "packages/releases/#{cli.args.release_name}/config.exs",
      []
    )

    Mix.Generator.copy_template(
      "#{@template_dir}/release/main.tf.template",
      "packages/releases/#{cli.args.release_name}/main.tf",
      []
    )

    Mix.Generator.copy_template(
      "#{@template_dir}/release/manifest.json.template",
      "packages/releases/#{cli.args.release_name}/manifest.json",
      []
    )

    Mix.Generator.create_file("packages/releases/#{cli.args.release_name}/.env.dev", "")
    Mix.Generator.create_file("packages/releases/#{cli.args.release_name}/.env.prod", "")
  end
end
