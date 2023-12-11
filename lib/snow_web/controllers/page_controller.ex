defmodule SnowWeb.PageController do
  use SnowWeb, :controller

  def home(conn, _params) do
    {:ok, image} = Image.new(100, 100, color: :white)
    {:ok, image} = Image.Draw.circle(image, 50, 50, 25, color: :black)
    filename = "priv/static/images/circle.png"
    File.rm(filename)
    Image.write(image, filename)
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
