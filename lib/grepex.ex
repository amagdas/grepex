defmodule Grepex do
  alias Grepex.Search

  @moduledoc """
  Documentation for Grepex.
  """

  @doc """
  ## ./grepex search_term
  """
  def main(args) do
    args
    |> parse_args
    |> process
  end

  defp parse_args(args) do
    case OptionParser.parse(args) do
      { _, [], _ } -> :help
      { _, terms, _ }
      -> {terms}
    end
  end

  defp process(:help) do
    IO.puts "Usage: ./grepex search-term"
  end

  defp process({terms}) do
    IO.inspect terms
    {terms}
    |> Search.search
    |> Grepex.Renderer.render_results
  end

end
