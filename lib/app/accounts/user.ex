defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    belongs_to :organization, App.Accounts.Organization
    many_to_many :teams, App.Accounts.Team, join_through: App.Accounts.TeamMembership

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :organization_id])
    |> validate_required([:email, :organization_id])
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+\.[^@\s]+$/)
    |> unique_constraint(:email)
    |> assoc_constraint(:organization)
  end
end