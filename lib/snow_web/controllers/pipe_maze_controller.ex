defmodule SnowWeb.PipeMazeController do
  use SnowWeb, :controller
  use Nebulex.Caching
  alias Snow.PipeMaze.Diagram

  def index(conn, _params) do
    render(conn, :index)
  end

  def image_of_loop(conn, params) do
    diagram =
      case params["name"] do
        "first" -> Diagram.first_example()
        "first-with-junk" -> Diagram.first_example_with_junk()
        "more-complex-example" -> Diagram.more_complex_example()
        "more-complex-example-with-junk" -> Diagram.more_complex_example_with_junk()
        "day10" -> Diagram.day10()
      end

    image = image(diagram)
    # {:ok, image} = Image.new(100, 100, color: :white)
    # {:ok, image} = Image.Draw.circle(image, 50, 50, 25, color: :black)
    {:ok, data} = Image.write(image, :memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  @decorate cacheable(cache: Snow.PipeMaze.Cache, key: {:pipe_maze_image, diagram})
  defp image(diagram) do
    loop = Diagram.find_the_loop(diagram, Diagram.starting_point(diagram))
    {cols, rows} = Diagram.dimensions(diagram)

    # {:ok, image} = Image.new(x, y, color: :white)
    {:ok, image} =
      Enum.map(0..(cols - 1), fn col ->
        Enum.map(0..(rows - 1), fn row ->
          symbol = Diagram.get(diagram, {row, col})
          in_loop = Enum.member?(loop, {row, col})

          tile(symbol, in_loop)
        end)
      end)
      |> List.flatten()
      |> Vix.Vips.Operation.arrayjoin(across: cols)

    image
  end

  defp shape_from_symbol(symbol, color \\ :black) do
    {:ok, image} = Image.new(3, 3, color: :white)

    case symbol do
      # | is a vertical pipe connecting north and south.
      ?| ->
        {:ok, _image} = Image.Draw.line(image, 1, 0, 1, 2, color: color)

      # - is a horizontal pipe connecting east and west.
      ?- ->
        {:ok, _image} = Image.Draw.line(image, 0, 1, 2, 1, color: color)

      # L is a 90-degree bend connecting north and east.
      ?L ->
        {:ok, image} = Image.Draw.line(image, 1, 1, 2, 1, color: color)
        {:ok, _image} = Image.Draw.line(image, 1, 1, 1, 0, color: color)

      # J is a 90-degree bend connecting north and west.
      ?J ->
        {:ok, image} = Image.Draw.line(image, 1, 1, 1, 0, color: color)
        {:ok, _image} = Image.Draw.line(image, 1, 1, 0, 1, color: color)

      # 7 is a 90-degree bend connecting south and west.
      ?7 ->
        {:ok, image} = Image.Draw.line(image, 1, 1, 0, 1, color: color)
        {:ok, _image} = Image.Draw.line(image, 1, 1, 1, 2, color: color)

      # F is a 90-degree bend connecting south and east.
      ?F ->
        {:ok, image} = Image.Draw.line(image, 1, 1, 2, 1, color: color)
        {:ok, _image} = Image.Draw.line(image, 1, 1, 1, 2, color: color)

      # S is the starting point
      ?S ->
        {:ok, {image, _}} = Image.Draw.flood(image, 0, 0, color: :red)
        {:ok, image}

      # . is empty ground
      ?. ->
        {:ok, image}
    end
  end

  defp tile(symbol, in_loop?) do
    {:ok, tile} =
      if in_loop? do
        shape_from_symbol(symbol)
      else
        shape_from_symbol(symbol, :gray)
      end

    tile
  end
end
