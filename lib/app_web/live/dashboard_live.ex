defmodule AppWeb.DashboardLive do
  use AppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, layout: {AppWeb.LayoutView, :live}}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section class="container">
      <h1>Dashboard</h1>
      <%= if @current_user do %>
        <p>Welcome, <%= @current_user.email %>!</p>
      <% else %>
        <p>You must sign in to view this page.</p>
      <% end %>
    </section>
    """
  end
end