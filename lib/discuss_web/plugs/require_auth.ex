defmodule DiscussWeb.Controllers.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers

  # notes: must have init and call func for a module Plug
  # notes: params for the call function is the params that would be returned if we called/used the init function
  # notes: if you return the conn object (connection) from a plug, that means everything is ok

  def init(_params) do
  end

  #
  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
        |> put_flash(:error, "You must be logged in.")
        |> redirect(to: Helpers.topic_path(conn, :index))
        |> halt()
    end
  end
end
