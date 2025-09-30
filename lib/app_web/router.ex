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

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end
end
