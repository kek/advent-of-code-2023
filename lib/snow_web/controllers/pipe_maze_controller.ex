defmodule SnowWeb.PipeMazeController do
  use SnowWeb, :controller
  use Nebulex.Caching
  alias Snow.PipeMaze.Diagram

  def index(conn, _params) do
    render(conn, :index, page_title: "Pipe Maze")
  end

  def image_of_loop(conn, params) do
    visualization =
      select_diagram(params["name"])
      |> image()

    {:ok, data} = Image.write(visualization, :memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  def flood_image_of_loop(conn, params) do
    diagram = select_diagram(params["name"])

    visualization =
      diagram
      |> image(:white)

    {visualization, white_cells} = flood(diagram, visualization)

    {:ok, data} = Image.write(visualization, :memory, suffix: ".png")

    conn
    |> put_resp_header("x-white-cells", "#{white_cells}")
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end

  def is_cell_white?(image, x, y) do
    pixels = fn i -> (i * 3)..(i * 3 + 2) end

    Enum.all?(
      for(x <- pixels.(x), y <- pixels.(y), do: {x, y}),
      fn {cr, cy} ->
        Image.get_pixel!(image, cr, cy) == [255, 255, 255]
      end
    )
  end

  defp select_diagram(name) do
    case name do
      "first" -> Diagram.first_example()
      "first-with-junk" -> Diagram.first_example_with_junk()
      "more-complex-example" -> Diagram.more_complex_example()
      "more-complex-example-with-junk" -> Diagram.more_complex_example_with_junk()
      "day10" -> Diagram.day10()
      "part-two-first" -> Diagram.part_two_first_example()
      "part-two-larger" -> Diagram.part_two_larger_example()
      "part-two-another" -> Diagram.part_two_another_example_with_junk_laying_around()
    end
  end

  @decorate cacheable(cache: Snow.PipeMaze.Cache, key: {:pipe_maze_image, diagram, junk_color})
  def image(diagram, junk_color \\ :gray) do
    loop = Diagram.find_the_loop(diagram, Diagram.starting_point(diagram))
    {cols, rows} = Diagram.dimensions(diagram)

    for y <- 0..(rows - 1),
        x <- 0..(cols - 1) do
      symbol = Diagram.get(diagram, {x, y})
      in_loop = Enum.member?(loop, {x, y})
      tile(symbol, in_loop, junk_color)
    end
    |> List.flatten()
    |> Vix.Vips.Operation.arrayjoin!(across: cols)
  end

  @decorate cacheable(cache: Snow.PipeMaze.Cache, key: {:pipe_maze_flood, diagram})
  defp flood(diagram, visualization) do
    {:ok, {visualization, _}} = Image.Draw.flood(visualization, 0, 0, color: :blue, equal: true)

    {cols, rows} = Diagram.dimensions(diagram)

    white_cells =
      for x <- 0..(cols - 1), y <- 0..(rows - 1) do
        is_cell_white?(visualization, x, y)
      end
      |> Enum.filter(&(&1 == true))
      |> Enum.count()

    {visualization, white_cells}
  end

  defp shape_from_symbol(symbol, color \\ :black) do
    image = Image.new!(3, 3, color: :white)

    case symbol do
      # | is a vertical pipe connecting north and south.
      ?| ->
        image |> Image.Draw.line!(1, 0, 1, 2, color: color)

      # - is a horizontal pipe connecting east and west.
      ?- ->
        image |> Image.Draw.line!(0, 1, 2, 1, color: color)

      # L is a 90-degree bend connecting north and east.
      ?L ->
        image
        |> Image.Draw.line!(1, 1, 2, 1, color: color)
        |> Image.Draw.line!(1, 1, 1, 0, color: color)

      # J is a 90-degree bend connecting north and west.
      ?J ->
        image
        |> Image.Draw.line!(1, 1, 1, 0, color: color)
        |> Image.Draw.line!(1, 1, 0, 1, color: color)

      # 7 is a 90-degree bend connecting south and west.
      ?7 ->
        image
        |> Image.Draw.line!(1, 1, 0, 1, color: color)
        |> Image.Draw.line!(1, 1, 1, 2, color: color)

      # F is a 90-degree bend connecting south and east.
      ?F ->
        image
        |> Image.Draw.line!(1, 1, 2, 1, color: color)
        |> Image.Draw.line!(1, 1, 1, 2, color: color)

      # S is the starting point
      ?S ->
        Image.Draw.flood!(image, 0, 0, color: :red)

      # . is empty ground
      ?. ->
        image
    end
  end

  defp tile(symbol, in_loop?, junk_color) do
    if in_loop? do
      shape_from_symbol(symbol)
    else
      shape_from_symbol(symbol, junk_color)
    end
  end
end
