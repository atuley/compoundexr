defmodule Compoundexr.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :balance, :integer
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
