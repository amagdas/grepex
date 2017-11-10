defmodule Grepex.Renderer do

  def render_results([results]) do
    results
    |> Enum.each(fn result -> render_result(result) end)
  end

  def render_results(val) do
    IO.puts "Search failed. Returned code: #{inspect val}"
  end

  defp render_result({idx, heading, url, description}) do
    render_url(idx, url)
    |> IO.puts

    render_heading(heading)
    |> IO.puts

    render_description(description)
    |> IO.puts

    stars()
    |> IO.puts
  end

  defp render_url(idx, url), do: IO.ANSI.red() <> "[#{idx}] #{url}" <> IO.ANSI.reset()

  defp render_heading(heading), do: IO.ANSI.green() <> heading <> IO.ANSI.reset()

  defp render_description(description), do: IO.ANSI.yellow() <> description <> IO.ANSI.reset()

  defp stars, do: String.duplicate "*", 20
end
