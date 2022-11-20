defmodule RssWeb.ErrorJSONTest do
  use RssWeb.ConnCase, async: true

  test "renders 404" do
    assert RssWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert RssWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
