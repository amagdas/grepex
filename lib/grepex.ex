defmodule Grepex do
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
    parse = OptionParser.parse(args)
    case parse do
      { _, [], _ } -> :help
      { _, [search_term], _ }
       -> {search_term}
    end
  end

  defp process(:help) do
    IO.puts "Usage: ./grepex search-term"
  end

  defp process({search_term}) do
    IO.inspect search_term
  end

end
