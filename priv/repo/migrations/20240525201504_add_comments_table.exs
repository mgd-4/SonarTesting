defmodule Sonar.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string

      add :post_id, references(:posts)

      timestamps(type: :utc_datetime)
    end
  end
end
