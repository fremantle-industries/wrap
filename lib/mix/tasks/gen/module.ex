defmodule Mix.Tasks.Wrap.Gen.Module do
  @moduledoc """
  """

  use Mix.Task

  @template_dir Path.expand("../../../templates", __DIR__)

  @cli_config [
    name: "wrap.gen.module",
    description: "Scaffold a module",
    about: """
    Example:

    mix wrap.gen.module my_module
    """,
    args: [
      module_name: [
        value_name: "MODULE_NAME",
        help: "wrap module",
        required: true,
        parser: :string
      ]
    ]
  ]

  @shortdoc "Scaffold a module"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = @cli_config |> Optimus.new!() |> Optimus.parse!(argv)

    Mix.Generator.create_directory("packages/modules/#{cli.args.module_name}")

    Mix.Generator.copy_template(
      "#{@template_dir}/module/variables.tf.template",
      "packages/modules/#{cli.args.module_name}/variables.tf",
      []
    )

    Mix.Generator.copy_template(
      "#{@template_dir}/module/main.tf.template",
      "packages/modules/#{cli.args.module_name}/main.tf",
      []
    )
  end
end
