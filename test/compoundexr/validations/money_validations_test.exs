defmodule Compoundexr.Validations.MoneyValidationsTest do
  use ExUnit.Case, async: true
  import Ecto.Changeset
  alias Compoundexr.Validations.MoneyValidations

  defmodule TestSchema do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    schema "test_schema" do
      field :money_field, Money.Ecto.Type
    end

    @types %{money_field: Money.Ecto.Type}

    def changeset(schema \\ %__MODULE__{}, attrs) do
      {schema, @types}
      |> cast(attrs, [:money_field])
      |> validate_required([:money_field])
      |> MoneyValidations.validate_money(:money_field)
    end

    def changeset_with_min(schema \\ %__MODULE__{}, attrs, min_amount) do
      {schema, @types}
      |> cast(attrs, [:money_field])
      |> validate_required([:money_field])
      |> MoneyValidations.validate_money(:money_field, min_amount: min_amount)
    end
  end

  describe "validate_money/2" do
    test "validates required field" do
      changeset = TestSchema.changeset(%{}, %{})
      assert "can't be blank" in errors_on(changeset).money_field
    end

    test "allows zero amount by default" do
      changeset = TestSchema.changeset(%{}, %{money_field: Money.new(0, :USD)})
      refute changeset.errors[:money_field]
    end

    test "allows amount up to 1 billion" do
      changeset = TestSchema.changeset(%{}, %{money_field: Money.new(1_000_000_000, :USD)})
      refute changeset.errors[:money_field]
    end

    test "rejects amount greater than 1 billion" do
      changeset = TestSchema.changeset(%{}, %{money_field: Money.new(1_000_000_001, :USD)})
      assert "must be less than or equal to 1,000,000,000" in errors_on(changeset).money_field
    end

    test "rejects negative amount" do
      changeset = TestSchema.changeset(%{}, %{money_field: Money.new(-1, :USD)})
      assert "must be greater than or equal to 0" in errors_on(changeset).money_field
    end
  end

  describe "validate_money/3 with min_amount option" do
    test "allows amount equal to min_amount" do
      changeset = TestSchema.changeset_with_min(%{}, %{money_field: Money.new(1, :USD)}, 1)
      refute changeset.errors[:money_field]
    end

    test "allows amount greater than min_amount" do
      changeset = TestSchema.changeset_with_min(%{}, %{money_field: Money.new(2, :USD)}, 1)
      refute changeset.errors[:money_field]
    end

    test "rejects amount less than min_amount" do
      changeset = TestSchema.changeset_with_min(%{}, %{money_field: Money.new(0, :USD)}, 1)
      assert "must be greater than 1" in errors_on(changeset).money_field
    end

    test "rejects amount equal to min_amount - 1" do
      changeset = TestSchema.changeset_with_min(%{}, %{money_field: Money.new(0, :USD)}, 1)
      assert "must be greater than 1" in errors_on(changeset).money_field
    end
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
