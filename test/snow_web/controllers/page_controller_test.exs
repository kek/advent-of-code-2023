defmodule SnowWeb.PageControllerTest do
  use SnowWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "DOCTYPE html"
  end

  test "GET /image-of-loop", %{conn: conn} do
    conn = get(conn, ~p"/image-of-loop")
    assert response(conn, 200)
  end
end
