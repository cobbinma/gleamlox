import glint.{CommandInput}
import gleam/list
import gleam/result.{map_error, then}
import gleam/erlang.{start_arguments}
import snag.{Result}
import gleam/erlang/file
import token
import scanner

fn interpret(input: CommandInput) -> Result(Nil) {
  case list.length(input.args) {
    1 ->
      run_file(
        input.args
        |> list.first
        |> result.unwrap(""),
      )
    _ -> snag.error("Usage: gleam run [script]")
  }
}

fn run_file(file: String) -> Result(Nil) {
  file.read(file)
  |> map_error(fn(_) { snag.Snag(issue: "unable to read file", cause: []) })
  |> then(run)
}

fn run(source: String) -> Result(Nil) {
  scanner.new(source)
  |> scanner.scan
  |> then(token.print_tokens)
}

pub fn main() {
  glint.new()
  |> glint.with_pretty_help(glint.default_pretty_help)
  |> glint.add_command(
    at: [],
    do: interpret,
    with: [],
    described: "jlox interpreter",
  )
  |> glint.run(start_arguments())
}
