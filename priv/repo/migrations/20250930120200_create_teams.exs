defmodule App.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:teams, [:organization_id])
    create unique_index(:teams, [:organization_id, :name], name: :teams_org_id_name_index)
  end
end