defmodule Grepex.App do
  use Application

  def start(_type, _args) do
    Grepex.SearchServer.run
  end

end
