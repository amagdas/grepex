defmodule Grepex do
  alias Grepex.SearchServer
  alias Grepex.IOHelpers

  @moduledoc """
  Command line tool for searching the web.
  Currently uses private search providers: ixquick
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
    terms
    |> SearchServer.search

    receive do
      {:ixquick_result, results } -> Grepex.Renderer.render_results results
    after
      20_000 ->
        IO.puts IOHelpers.bad_news_marker <> "Timeout: no results received in 20s" <> IOHelpers.bad_news_marker
        :timeout
    end
  end

end
