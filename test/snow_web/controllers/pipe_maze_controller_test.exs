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

  test "get number of white cells", %{conn: conn} do
    conn = get(conn, ~p"/pipe-maze/loop/first/flood")
    assert Plug.Conn.get_resp_header(conn, "x-white-cells") == ["1"]
    assert response(conn, 200)
  end

  test "get number of white cells - test 2", %{conn: conn} do
    conn = get(conn, ~p"/pipe-maze/loop/part-two-first/flood")
    assert Plug.Conn.get_resp_header(conn, "x-white-cells") == ["4"]
    assert response(conn, 200)
  end
end
