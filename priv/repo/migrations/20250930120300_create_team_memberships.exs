defmodule App.Repo.Migrations.CreateTeamMemberships do
  use Ecto.Migration

  def change do
    create table(:team_memberships) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role, :string, null: false, default: "member"

      timestamps()
    end

    create index(:team_memberships, [:team_id])
    create index(:team_memberships, [:user_id])
    create unique_index(:team_memberships, [:team_id, :user_id], name: :team_memberships_team_id_user_id_index)
  end
end