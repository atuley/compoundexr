defmodule Compoundexr.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  alias Compoundexr.Accounts.User

  schema "assets" do
    field :name, :string
    field :balance, :integer
    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:name, :balance, :user_id])
    |> validate_required([:name, :balance, :user_id])
  end
end
