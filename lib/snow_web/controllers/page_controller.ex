defmodule SnowWeb.PageController do
  use SnowWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
