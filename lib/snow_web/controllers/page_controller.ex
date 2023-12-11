defmodule SnowWeb.PageController do
  use SnowWeb, :controller

  def home(conn, _params) do
    render(conn, :home, page_title: "Something is wrong with global snow production")
  end
end
