defmodule Compoundexr.Compound.CalculationData do
  @types %{
    starting_balance: Money.Ecto.Type,
    interest_rate: :float,
    years: :integer,
    contributions: Money.Ecto.Type,
    contribution_growth_rate: :float,
    tax_rate: :float
  }
  defstruct starting_balance: nil,
            interest_rate: nil,
            years: nil,
            contributions: nil,
            contribution_growth_rate: nil,
            tax_rate: nil

  import Ecto.Changeset
  alias Compoundexr.Validations.MoneyValidations

  @fields Map.keys(@types)

  def changeset(calculation_data \\ %__MODULE__{}, params) do
    {calculation_data, @types}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:years, greater_than: 0, less_than_or_equal_to: 50)
    |> validate_number(:interest_rate, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000)
    |> validate_number(:contribution_growth_rate,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1000
    )
    |> validate_number(:tax_rate, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000)
    |> MoneyValidations.validate_money(:starting_balance, min_amount: 1)
    |> MoneyValidations.validate_money(:contributions)
  end
end
