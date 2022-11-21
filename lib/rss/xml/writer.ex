defmodule Rss.XML.Writer do
  @moduledoc """
  This module is responsible for building the XML of combined RSS feeds. The source code was
  taken from elixir-rss, specifically this branch: https://github.com/BennyHallett/elixir-rss/pull/14
  """
  @spec feed(String.t(), [String.t()]) :: String.t()
  def feed(channel, items) do
    """
    <?xml version="1.0" encoding="utf-8"?>
    <rss version="2.0">
    <channel>
    #{channel}#{Enum.join(items, "")}</channel>
    </rss>
    """
  end

  @spec channel(String.t(), String.t(), String.t(), String.t(), String.t()) :: String.t()
  def channel(title, link, desc, date, lang) do
    """
      #{element(:title, title)}
      #{element(:link, link)}
      #{element(:description, desc)}
      #{element(:lastBuildDate, date)}
      #{element(:language, lang)}
    """
  end

  @spec item(String.t(), String.t(), String.t(), String.t(), String.t()) :: String.t()
  def item(title, desc, pub_date, link, guid) do
    """
    <item>
      #{element(:title, title)}
      #{element(:description, desc)}
      #{element(:pubDate, pub_date)}
      #{element(:link, link)}
      #{element(:guid, guid)}
    </item>
    """
  end

  defp element(tag, text) do
    text_chars = to_charlist(text)
    :xmerl.export_simple_element({tag, [text_chars]}, :xmerl_xml)
  end
end
