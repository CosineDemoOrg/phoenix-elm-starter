defmodule AppWeb.Router do
  use AppWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pow.Plug.Session, otp_app: :app
    plug AppWeb.Plugs.FetchCurrentUser
  end

  # re-enable this when needed:
  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", AppWeb do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()

    get "/", PageController, :index
  end

  import Phoenix.LiveView.Router

  live_session :default, on_mount: {AppWeb.LiveAuth, :mount_current_user} do
    scope "/", AppWeb do
      pipe_through :browser

      # Public LiveViews can go here

      # Example protected LiveView (requires auth)
      live "/dashboard", DashboardLive, :index, on_mount: {AppWeb.LiveAuth, :ensure_authenticated}
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end
end
