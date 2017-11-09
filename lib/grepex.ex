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
    render_url(idx, url)
    |> IO.puts

    render_heading(heading)
    |> IO.puts

    render_description(description)
    |> IO.puts

    stars
    |> IO.puts
  end

  defp render_url(idx, url), do: IO.ANSI.red() <> "[#{idx}] #{url}" <> IO.ANSI.reset()
  defp render_heading(heading), do: IO.ANSI.green() <> heading <> IO.ANSI.reset()
  defp render_description(description), do: IO.ANSI.yellow() <> description <> IO.ANSI.reset()

  defp good_news_marker, do: IO.ANSI.green() <> String.duplicate(<<0x1F603 :: utf8>>, 5) <> IO.ANSI.reset()
  defp bad_news_marker, do: IO.ANSI.red() <> String.duplicate(<<0x1F630 :: utf8>>, 5) <> IO.ANSI.reset()

  defp stars, do: String.duplicate "*", 20

end
