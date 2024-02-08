defmodule KQWeb.InitAssigns do
  @moduledoc """
  Checks if user is authenticated as admin and sets assign
  """

  import Phoenix.Component

  def on_mount(:default, _arams, session, socket) do
    if session["is_admin"] do
      {:cont, assign(socket, :is_admin, true)}
    else
      {:cont, assign(socket, :is_admin, false)}
    end
  end
end
