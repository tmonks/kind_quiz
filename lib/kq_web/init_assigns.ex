defmodule KQWeb.InitAssigns do
  @moduledoc """
  Checks if user is authenticated and sets assign
  """

  import Phoenix.Component

  def on_mount(:default, _arams, session, socket) do
    if session["authenticated"] do
      {:cont, assign(socket, :authenticated, true)}
    else
      {:cont, assign(socket, :authenticated, false)}
    end
  end
end
