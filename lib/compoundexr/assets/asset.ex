defmodule Compoundexr.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Compoundexr.Validations.MoneyValidations
  alias Compoundexr.Accounts.User

  schema "assets" do
    field :name, :string
    field :balance, Money.Ecto.Type
    belongs_to :user, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(asset \\ %__MODULE__{}, attrs) do
    asset
    |> cast(attrs, [:name, :balance, :user_id])
    |> validate_required([:name, :balance, :user_id])
    |> MoneyValidations.validate_money(:balance)
  end
end
