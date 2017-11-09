defmodule Grepex do
  alias Grepex.Search

  @moduledoc """
  Documentation for Grepex.
  """

  @doc """
  ## ./grepex search_term
  """
  def main(args) do
    t1 = NaiveDateTime.utc_now
    res = args
    |> parse_args
    |> process
    t2 = NaiveDateTime.utc_now
    IO.puts "grepex took: #{NaiveDateTime.diff(t2, t1)} seconds"
    res
  end

  defp parse_args(args) do
    t1 = NaiveDateTime.utc_now
    parse = OptionParser.parse(args)
    res = case parse do
      { _, [], _ } -> :help
        { _, terms, _ }
        -> {terms}
    end
    t2 = NaiveDateTime.utc_now
    IO.puts "parse_args took: #{NaiveDateTime.diff(t2, t1)} seconds"
    res
  end

  defp process(:help) do
    IO.puts "Usage: ./grepex search-term"
  end

  defp process({terms}) do
    IO.inspect terms
    t1 = NaiveDateTime.utc_now
    res = {terms}
          |> Search.search
          |> render_results
    t2 = NaiveDateTime.utc_now
    IO.puts "process took: #{NaiveDateTime.diff(t2, t1)} seconds"
    res
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
