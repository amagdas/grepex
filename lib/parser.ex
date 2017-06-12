defmodule Grepex.Parser do

  def parse_html(html) do
    for n <- [1 .. 10], do: n
    |> Enum.map(fn id -> Floki.find(html, "#result#{id}") |> parse_result(id) end)
  end

  def parse_result(result, idx) do
    heading = Floki.find(result, "span.result_url_heading") |> parse_element
    url = Floki.find(result, "span.url") |> parse_element
    description = Floki.find(result, "p.desc") |> parse_element
    {idx, heading, url, description}
  end

  defp parse_element([]), do: ""
  defp parse_element([{_, _, []}]), do: ""
  defp parse_element([{_, _, [value]}]), do: value

end
