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

  def process(:help) do
    IO.puts "Usage: ./grepex search-term"
  end

  def process({terms}) do
    [term | _] = terms

    first = :binary.first(term)

    entry =
      Enum.find(table(), fn {enum, _node} ->
        first in enum
      end)

    IO.inspect entry
    search_node = elem(entry, 1)

    case Enum.any?(Node.list(), fn node_name -> node_name == search_node end) do
      true ->
        # If the entry node is the current node
        if search_node == node() do
          terms
          |> SearchServer.search
        else
          GenServer.cast({IxQuick, search_node}, {:search, terms, self()})
        end
      # node not found in the cluster, run it on the current node
      false ->
        terms
        |> SearchServer.search
    end

    wait_for_response
  end

  def wait_for_response do
    receive do
      {:ixquick_result, results } -> Grepex.Renderer.render_results results
    after
      1_000 ->
        IO.puts IOHelpers.bad_news_marker() <> "Still waiting: no results received yet" <> IOHelpers.bad_news_marker()
        wait_for_response
    end
  end

  defp table do
    Application.fetch_env!(:grepex, :routing_table)
  end

end
