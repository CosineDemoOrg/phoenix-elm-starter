defmodule AppWeb.LiveAuth do
  import Phoenix.LiveView
  alias App.Repo
  alias App.Users.User

  # Assigns current_user if a current_user_id is present in the session
  def on_mount(:mount_current_user, _params, session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        with id when not is_nil(id) <- session["current_user_id"],
             %User{} = user <- Repo.get(User, id) do
          user
        else
          _ -> nil
        end
      end)

    {:cont, socket}
  end

  # Ensures a user is authenticated, otherwise redirects to sign in
  def on_mount(:ensure_authenticated, _params, session, socket) do
    case session["current_user_id"] do
      nil ->
        {:halt, redirect(socket, to: AppWeb.Router.Helpers.pow_session_path(socket, :new))}

      id ->
        user = Repo.get(User, id)
        {:cont, assign(socket, :current_user, user)}
    end
  end
end