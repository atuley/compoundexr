defmodule Compoundexr.Compound.CalculationData do
  @types %{starting_balance: Money.Ecto.Type, interest_rate: :float, years: :integer}
  defstruct starting_balance: nil, interest_rate: nil, years: nil

  import Ecto.Changeset

  @fields Map.keys(@types)

  def changeset(calculation_data \\ %__MODULE__{}, params) do
    {calculation_data, @types}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:years, greater_than: 0)
  end
end
