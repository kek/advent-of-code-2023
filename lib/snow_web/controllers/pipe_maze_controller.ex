defmodule SnowWeb.PipeMazeController do
  use SnowWeb, :controller
  alias Snow.PipeMaze.Diagram

  def index(conn, _params) do
    render(conn, :index)
  end

  def image_of_loop(conn, _params) do
    diagram = Diagram.first_example()
    loop = Diagram.find_the_loop(diagram, Diagram.starting_point(diagram))
    {cols, rows} = Diagram.dimensions(diagram)

    # {:ok, image} = Image.new(x, y, color: :white)
    {:ok, image} =
      Enum.map(0..(rows - 1), fn row ->
        Enum.map(0..(cols - 1), fn col ->
          _symbol = Diagram.get(diagram, {row, col})
          in_loop = Enum.member?(loop, {row, col})
          color = if in_loop, do: :black, else: :white
          {:ok, tile} = Image.new(3, 3, color: color)

          tile
        end)
      end)
      |> List.flatten()
      |> Vix.Vips.Operation.arrayjoin(across: cols)

    # {:ok, image} = Image.new(100, 100, color: :white)
    # {:ok, image} = Image.Draw.circle(image, 50, 50, 25, color: :black)
    {:ok, data} = Image.write(image, :memory, suffix: ".png")

    conn
    |> put_resp_content_type("image/png")
    |> resp(200, data)
  end
end
