defmodule KQWeb.AuthController do
  use KQWeb, :controller

  def login(conn, _params) do
    config = Application.get_env(:quiz, :auth)

    conn =
      Plug.BasicAuth.basic_auth(conn,
        username: Keyword.fetch!(config, :username),
        password: Keyword.fetch!(config, :password)
      )

    if conn.halted do
      conn
    else
      conn
      |> put_session("is_admin", true)
      |> redirect(to: "/")
    end
  end
end
