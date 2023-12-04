defmodule KindQuizWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use KindQuizWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Plug.Conn

  using do
    quote do
      # The default endpoint for testing
      @endpoint KindQuizWeb.Endpoint

      use KindQuizWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import KindQuizWeb.ConnCase
    end
  end

  setup tags do
    KindQuiz.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def login_user(%{conn: conn}) do
    auth_header =
      Application.get_env(:quiz, :auth)
      |> Keyword.take([:username, :password])
      |> Keyword.values()
      |> Enum.join(":")
      |> Base.encode64()

    conn = put_req_header(conn, "authorization", "Basic #{auth_header}")

    %{conn: conn}
  end
end
