defmodule Grepex.SearchServer do
  use Supervisor
  @name IxQuickSupervisor

  def run do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    Supervisor.init([Grepex.IxQuickSearch], strategy: :simple_one_for_one)
  end

  def search(terms, from \\ self()) when is_list(terms) do
    IO.puts "Searching for #{terms} sent by: #{inspect from}"
    {:ok, search_agent} = Supervisor.start_child(@name, [])
    GenServer.cast(search_agent, {:search, terms, from})
  end

end
