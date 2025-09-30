defmodule App.Accounts.TeamMembership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_memberships" do
    belongs_to :team, App.Accounts.Team
    belongs_to :user, App.Accounts.User
    field :role, Ecto.Enum, values: [:member, :admin], default: :member

    timestamps()
  end

  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:team_id, :user_id, :role])
    |> validate_required([:team_id, :user_id])
    |> unique_constraint([:team_id, :user_id], name: :team_memberships_team_id_user_id_index)
    |> assoc_constraint(:team)
    |> assoc_constraint(:user)
  end
end