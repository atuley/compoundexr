defmodule Compoundexr.Validations.MoneyValidations do
  import Ecto.Changeset

  @max_amount 1_000_000_000

  def validate_money(changeset, field, opts \\ []) do
    min_amount = Keyword.get(opts, :min_amount, 0)

    validate_change(changeset, field, fn _, value ->
      cond do
        is_nil(value) ->
          [{field, "can't be blank"}]

        value.amount < min_amount ->
          [
            {field,
             "must be greater than #{if min_amount == 0, do: "or equal to ", else: ""}#{min_amount}"}
          ]

        value.amount > @max_amount ->
          [{field, "must be less than or equal to 1,000,000,000"}]

        true ->
          []
      end
    end)
  end
end
