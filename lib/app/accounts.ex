defmodule App.Accounts do
  @moduledoc """
  Accounts context: organizations, users, teams and memberships.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.{Organization, User, Team, TeamMembership}

  # Organizations

  def list_organizations, do: Repo.all(Organization)

  def get_organization!(id), do: Repo.get!(Organization, id)

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def update_organization(%Organization{} = org, attrs) do
    org
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = org), do: Repo.delete(org)

  # Users

  def list_users, do: Repo.all(User)

  def list_org_users(org_id) do
    from(u in User, where: u.organization_id == ^org_id)
    |> Repo.all()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def move_user_to_org(%User{} = user, %Organization{} = org) do
    update_user(user, %{organization_id: org.id})
  end

  def delete_user(%User{} = user), do: Repo.delete(user)

  # Teams

  def list_teams(org_id \\ nil) do
    base = from(t in Team, order_by: t.name)

    case org_id do
      nil -> Repo.all(base)
      id -> base |> where([t], t.organization_id == ^id) |> Repo.all()
    end
  end

  def get_team!(id), do: Repo.get!(Team, id)

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def delete_team(%Team{} = team), do: Repo.delete(team)

  # Team memberships

  def add_user_to_team(%User{} = user, %Team{} = team, role \\ :member) do
    %TeamMembership{}
    |> TeamMembership.changeset(%{user_id: user.id, team_id: team.id, role: role})
    |> Repo.insert()
  end

  def remove_user_from_team(%User{} = user, %Team{} = team) do
    from(m in TeamMembership, where: m.user_id == ^user.id and m.team_id == ^team.id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      membership -> Repo.delete(membership)
    end
  end

  def list_team_members(%Team{} = team) do
    from(u in User,
      join: m in TeamMembership, on: m.user_id == u.id,
      where: m.team_id == ^team.id,
      select: %{user: u, role: m.role}
    )
    |> Repo.all()
  end
end