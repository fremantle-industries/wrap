defmodule Mix.Tasks.Wrap.Gen.Present do
  @moduledoc """
  """

  use Mix.Task

  @template_dir Path.expand("../../../templates", __DIR__)

  @cli_config [
    name: "wrap.gen.present",
    description: "Scaffold a release present",
    about: """
    Example:

    mix wrap.gen.present my_present
    """,
    args: [
      release_name: [
        value_name: "RELEASE_NAME",
        help: "wrap present",
        required: true,
        parser: :string
      ]
    ]
  ]

  @shortdoc "Scaffold a release"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = @cli_config |> Optimus.new!() |> Optimus.parse!(argv)

    Mix.Generator.create_directory("presents/#{cli.args.release_name}")

    Mix.Generator.copy_template(
      "#{@template_dir}/present/main.tf.template",
      "presents/#{cli.args.release_name}/main.tf",
      []
    )

    Mix.Generator.copy_template(
      "#{@template_dir}/present/manifest.json.template",
      "presents/#{cli.args.release_name}/manifest.json",
      []
    )

    Mix.Generator.create_file("presents/#{cli.args.release_name}/.env.dev", "")
    Mix.Generator.create_file("presents/#{cli.args.release_name}/.env.prod", "")
  end
end
