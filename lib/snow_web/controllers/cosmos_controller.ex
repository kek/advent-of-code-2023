defmodule SnowWeb.CosmosHTML do
  use SnowWeb, :html

  embed_templates "cosmos_html/*"
end

defmodule SnowWeb.CosmosController do
  use SnowWeb, :controller

  def index(conn, params) do
    _ = params

    render(conn, :index, page_title: "Cosmic Expansion")
  end
end
