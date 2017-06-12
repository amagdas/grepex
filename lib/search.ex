defmodule Grepex.Search do
  alias Grepex.Parser

  @ixquick_url "https://www.ixquick.eu/do/search/"
  @ixquick_headers [
    {"Content-Type", "application/x-www-form-urlencoded"},
    {"User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0"},
    {"Accept", "tex/html"}
  ]

  def search({terms}) do
    body = terms
           |> Enum.join("+")
           |> ixquick_body

    case HTTPoison.post(@ixquick_url, body, @ixquick_headers) do
      { :ok, %HTTPoison.Response{body: response} } -> Parser.parse_html(response) |> IO.inspect
      { :error, %HTTPoison.Error{reason: reason} } -> IO.inspect reason
    end
  end

  defp ixquick_body(search_term) do
    {:form, [query: search_term]}
  end

end
