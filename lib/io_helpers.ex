defmodule Grepex.IOHelpers do
  def good_news_marker, do: IO.ANSI.green() <> String.duplicate(<<0x1F603 :: utf8>>, 5) <> IO.ANSI.reset()

  def bad_news_marker, do: IO.ANSI.red() <> String.duplicate(<<0x1F630 :: utf8>>, 5) <> IO.ANSI.reset()

end
