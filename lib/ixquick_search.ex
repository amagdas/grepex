defmodule Grepex.IxQuickSearch do
  use GenServer

  alias Grepex.ResponseParser

  # Client
  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def search(pid, terms) when is_list(terms) do
    GenServer.cast(pid, {:search, terms, self()})
  end

  # Server (callbacks)

  def handle_cast({:search, terms, from}, state) do
    IO.puts "Got search request from #{inspect from}"
    result = execute_search(terms)
    send from, {:ixquick_result, result}
    {:noreply, terms}
  end

  def handle_cast(request, state) do
    super(request, state)
  end

  @ixquick_url "https://www.ixquick.eu/do/search/"
  @ixquick_headers [
    {"Content-Type", "application/x-www-form-urlencoded"},
    {"User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0"},
    {"Accept", "tex/html"}
  ]

  defp execute_search(terms) when is_list(terms) do
    body = terms
           |> Enum.join("+")
           |> ixquick_body

    case HTTPoison.post(@ixquick_url, body, @ixquick_headers) do
      { :ok, %HTTPoison.Response{body: response} } ->
        ResponseParser.parse_html(response)

      { :error, %HTTPoison.Error{reason: reason} } ->
        reason
    end
  end

  defp ixquick_body(search_term) do
    {:form, [query: search_term]}
  end
end
