defmodule AppWeb.Plugs.FetchCurrentUser do
  @moduledoc false
  import Plug.Conn
  alias Pow.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Plug.current_user(conn)

    conn
    |> assign(:current_user, current_user)
    |> maybe_put_user_id_in_session(current_user)
  end

  defp maybe_put_user_id_in_session(conn, nil), do: conn

  defp maybe_put_user_id_in_session(conn, %{id: id}) do
    put_session(conn, "current_user_id", id)
  end
end