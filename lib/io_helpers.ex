defmodule Grepex.IOHelpers do
  def good_news_marker, do: IO.ANSI.green() <> String.duplicate("*", 5) <> IO.ANSI.reset()

  def bad_news_marker, do: IO.ANSI.red() <> String.duplicate("*", 5) <> IO.ANSI.reset()

end
