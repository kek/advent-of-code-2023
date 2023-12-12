defmodule SnowWeb.CosmosController do
  alias Snow.Cosmos.Examples
  alias Snow.Cosmos.SpaceMap
  use SnowWeb, :controller

  def index(conn, _params) do
    {:ok, space_map, "", _, _, _} = SpaceMap.document(Examples.example_1())
    render(conn, :index, page_title: "Cosmic Expansion", space_map: space_map)
  end

  def image(conn, %{"name" => name}) do
    data =
      case name do
        "example" ->
          {:ok, space_map, _, _, _, _} = SpaceMap.document(Examples.example_1())

          space_image(space_map)
          |> Image.resize!(20)

        "real" ->
          {:ok, space_map, _, _, _, _} = SpaceMap.document(Examples.my_input())

          space_image(space_map)
          |> Image.resize!(4)

        _ ->
          Image.new!(100, 100, color: :red)
      end
      |> Image.write!(:memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  def space_image(space_map) do
    height = Enum.count(space_map)
    width = Enum.count(hd(space_map))

    coords =
      for y <- 0..(height - 1),
          x <- 0..(width - 1),
          do: {x, y}

    Enum.reduce(
      coords,
      Image.new!(height, width, color: :gray),
      fn {x, y}, image ->
        color =
          case SpaceMap.get(space_map, {x, y}) do
            :space -> :black
            :galaxy -> [255, 255, 200]
          end

        Image.Draw.point!(image, x, y, color: color)
      end
    )
  end
end
