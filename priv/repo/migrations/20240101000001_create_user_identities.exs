defmodule App.Repo.Migrations.CreateUserIdentities do
  use Ecto.Migration

  def change do
    create table(:user_identities) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :provider, :string, null: false
      add :uid, :string, null: false

      add :tokens, :map
      add :refresh_token, :string
      add :expires_at, :utc_datetime

      timestamps(updated_at: false)
    end

    create unique_index(:user_identities, [:provider, :uid])
    create index(:user_identities, [:user_id])
  end
end