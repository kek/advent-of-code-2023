defmodule SnowWeb.PipeMazeControllerTest do
  use SnowWeb.ConnCase

  test "GET /pipe-maze", %{conn: conn} do
    conn = get(conn, ~p"/pipe-maze")
    assert html_response(conn, 200) =~ "DOCTYPE html"
  end

  test "GET /pipe-maze/loop/first", %{conn: conn} do
    conn = get(conn, ~p"/pipe-maze/loop/first")
    assert response(conn, 200)
  end
end
