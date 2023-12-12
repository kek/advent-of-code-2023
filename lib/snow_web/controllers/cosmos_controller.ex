defmodule SnowWeb.CosmosController do
  alias Snow.Cosmos.Examples
  alias Snow.Cosmos.Universe
  use SnowWeb, :controller

  def index(conn, _params) do
    {:ok, space_map, "", _, _, _} = Universe.document(Examples.example_1())
    render(conn, :index, page_title: "Cosmic Expansion", space_map: space_map)
  end

  def image(conn, %{"name" => name}) do
    data =
      case name do
        "example" ->
          {:ok, universe, _, _, _, _} = Universe.document(Examples.example_1())

          draw(universe)
          |> Image.resize!(20)

        "real" ->
          {:ok, universe, _, _, _, _} = Universe.document(Examples.my_input())

          draw(universe)
          |> Image.resize!(4)

        _ ->
          Image.new!(100, 100, color: :red)
      end
      |> Image.write!(:memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  def expand(conn, %{"name" => name}) do
    data =
      case name do
        "example" ->
          {:ok, universe, _, _, _, _} = Universe.document(Examples.example_1())

          universe
          |> Universe.expand()
          |> draw()
          |> Image.resize!(20)

        "real" ->
          {:ok, universe, _, _, _, _} = Universe.document(Examples.my_input())

          universe
          |> Universe.expand()
          |> draw()
          |> Image.resize!(4)

        _ ->
          Image.new!(100, 100, color: :red)
      end
      |> Image.write!(:memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  defp draw(universe) do
    height = Enum.count(universe)
    width = Enum.count(hd(universe))

    coords =
      for y <- 0..(height - 1),
          x <- 0..(width - 1),
          do: {x, y}

    Enum.reduce(
      coords,
      Image.new!(width, height, color: :gray),
      fn {x, y}, image ->
        color =
          case Universe.get(universe, {x, y}) do
            :space -> :black
            :galaxy -> [255, 255, 200]
          end

        Image.Draw.point!(image, x, y, color: color)
      end
    )
  end
end
