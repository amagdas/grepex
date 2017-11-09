defmodule Grepex.Renderer do
  def render_results([results]) do
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
