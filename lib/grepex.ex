defmodule Grepex do

  @moduledoc """
  Documentation for Grepex.
  """

  @ixquick_url "https://www.ixquick.eu/do/search/"
  @ixquick_headers [
    {"Content-Type", "application/x-www-form-urlencoded"},
    {"User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0"},
    {"Accept", "tex/html"}
  ]

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
    {terms} |> search
  end

  def search({terms}) do
    body = terms
           |> prepare_search_term
           |> ixquick_body

    case HTTPoison.post(@ixquick_url, body, @ixquick_headers) do
      { :ok, %HTTPoison.Response{body: response} } ->
        response
      { :error, %HTTPoison.Error{reason: reason} } -> IO.inspect reason
    end
  end

  def parse_html(html) do
    html
    |> Floki.find("div.result")
    |> parse_headings
    |> parse_urls
    |> parse_descriptions
    |> beautify_result
  end

  def parse_headings(search_results) do
    headings = search_results
               |> Floki.find("span.result_url_heading")
               |> Enum.map(fn x -> parse_element(x) end)
    {search_results, %{headings: headings}}
  end

  def parse_urls({search_results, result}) do
    urls = search_results
           |> Floki.find("span.url")
           |> Enum.map(fn x -> parse_element(x) end)
    {search_results, Map.put(result, :urls, urls)}
  end

  def parse_descriptions({search_results, result}) do
    descriptions = search_results
                   |> Floki.find("p.desc")
                   |> Enum.map(fn x -> parse_element(x) end)
    {search_results, Map.put(result, :descriptions, descriptions)}
  end
  def beautify_result({_, %{headings: headings, urls: urls, descriptions: descriptions}}) do
    Enum.zip([headings, urls, descriptions])
  end

  defp parse_element({_, _, []}), do: ""
  defp parse_element({_, _, [value]}), do: value

  defp prepare_search_term(terms) do
    not_empty = Enum.filter(terms, (fn x -> String.length(x) > 0 end))
    Enum.join(not_empty, "+")
  end

  defp ixquick_body(search_term) do
    {:form, [query: search_term]}
  end

end
