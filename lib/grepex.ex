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
      { _, [search_term], _ }
       -> {search_term}
    end
  end

  defp process(:help) do
    IO.puts "Usage: ./grepex search-term"
  end

  defp process({search_term}) do
    IO.inspect search_term
    {search_term} |> search
  end

  defp search({search_term}) do
    body = ixquick_body(search_term)
    case HTTPoison.post(@ixquick_url, body, @ixquick_headers) do
      { :ok, response } -> IO.inspect response
      { :error, %HTTPoison.Error{reason: reason} } -> IO.inspect reason
    end
  end

  defp ixquick_body(search_term) do
    {:form, [key: "search_term"]}
  end

end
