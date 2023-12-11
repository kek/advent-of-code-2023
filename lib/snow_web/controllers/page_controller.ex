defmodule SnowWeb.PageController do
  use SnowWeb, :controller

  def home(conn, _params) do
    render(conn, :home, page_title: "Advent of Code 2023")
  end
end
