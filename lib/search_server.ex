defmodule Grepex.SearchServer do
  import Supervisor.Spec

  def run do
    children = [
      worker(Grepex.IxQuickSearch, [%{}, [name: IxQuick]])
    ]

    # Start the supervisor with our child
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def search(terms) when is_list(terms) do
    GenServer.cast(IxQuick, {:search, terms, self()})
  end

end
