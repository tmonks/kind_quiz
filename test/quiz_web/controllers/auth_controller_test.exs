defmodule KQWeb.AuthControllerTest do
  use KQWeb.ConnCase, async: true

  describe "GET /auth" do
    test "returns 401 when not logged in", %{conn: conn} do
      conn = get(conn, "/login")
      assert response(conn, 401)
    end

    test "returns 401 with invalid credentials", %{conn: conn} do
      auth_header = "Basic " <> Base.encode64("wrong:password")

      conn = put_req_header(conn, "authorization", auth_header)
      conn = get(conn, "/login")
      assert response(conn, 401)
    end

    test "redirects and updates session with valid credentials", %{conn: conn} do
      username = Application.get_env(:quiz, :auth)[:username]
      password = Application.get_env(:quiz, :auth)[:password]

      auth_header = "Basic " <> Base.encode64("#{username}:#{password}")
      conn = put_req_header(conn, "authorization", auth_header)
      conn = get(conn, "/login")

      # assert redirected to "/"
      assert response(conn, 302)
      assert redirected_to(conn) == "/"

      # session now contains authenticated = true
      assert get_session(conn, :authenticated) == true
    end
  end
end
