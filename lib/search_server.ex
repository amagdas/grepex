defmodule Grepex.SearchServer do
  import Supervisor.Spec

  def run do
    children = [
      worker(Grepex.IxQuickSearch, [%{}, [name: IxQuick]])
    ]

    # Start the supervisor with our child
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def search(terms, from \\ self()) when is_list(terms) do
    IO.puts "Searching for #{terms} sent by: #{inspect from}"
    GenServer.cast(IxQuick, {:search, terms, from})
  end

end
