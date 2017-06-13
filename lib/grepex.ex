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
    parse = OptionParser.parse(args)
    case parse do
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
    |> render_results
  end

  defp render_results([results]) do
    results
    |> Enum.each(fn result -> render_result(result) end)
  end

  defp render_result({idx, heading, url, description}) do
    [:red, :bright, "[#{idx}] #{url}"]
    |> IO.ANSI.format
    |> IO.puts

    [:green, heading]
    |> IO.ANSI.format
    |> IO.puts

    [:gray, description]
    |> IO.ANSI.format
    |> IO.puts
  end

end
