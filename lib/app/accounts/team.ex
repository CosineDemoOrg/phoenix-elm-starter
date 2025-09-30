defmodule App.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    belongs_to :organization, App.Accounts.Organization
    many_to_many :users, App.Accounts.User, join_through: App.Accounts.TeamMembership

    timestamps()
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
    |> validate_length(:name, min: 2)
    |> unique_constraint([:organization_id, :name], name: :teams_org_id_name_index)
    |> assoc_constraint(:organization)
  end
end