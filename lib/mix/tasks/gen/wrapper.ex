defmodule Mix.Tasks.Wrap.Gen.Wrapper do
  @moduledoc """
  """

  use Mix.Task

  @template_dir Path.expand("../../../templates", __DIR__)

  @cli_config [
    name: "wrap.gen.wrapper",
    description: "Scaffold a wrapper module",
    about: """
    Example:

    mix wrap.gen.wrapper my_wrapper
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

  @shortdoc "Scaffold a wrapper module"
  @spec run([String.t()]) :: no_return
  def run(argv) do
    cli = @cli_config |> Optimus.new!() |> Optimus.parse!(argv)

    Mix.Generator.create_directory("wrappers/#{cli.args.module_name}")

    Mix.Generator.copy_template(
      "#{@template_dir}/wrapper/variables.tf.template",
      "wrappers/#{cli.args.module_name}/variables.tf",
      []
    )

    Mix.Generator.copy_template(
      "#{@template_dir}/wrapper/main.tf.template",
      "wrappers/#{cli.args.module_name}/main.tf",
      []
    )
  end
end
