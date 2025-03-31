defmodule Compoundexr.CompoundTest do
  use Compoundexr.DataCase

  import Money.Sigils

  alias Compoundexr.Compound.Result
  alias Compoundexr.Compound

  describe "calculate/1" do
    test "returns calculation with valid calulation data" do
      raw_calculation_data = %{
        "starting_balance" => "10000000",
        "interest_rate" => "20",
        "years" => "20",
        "contributions" => "2000000",
        "contribution_growth_rate" => "2",
        "tax_rate" => "30"
      }

      assert {:ok,
              %Result{
                final_balance: ~M[34172727364],
                final_contribution: ~M[291362236],
                return_after_taxes: "14.00"
              }} = Compound.calculate(raw_calculation_data)
    end

    test "returns error with invalid calulation data" do
      raw_calculation_data = %{
        "starting_balance" => "10000000",
        "interest_rate" => "20",
        "years" => "0"
      }

      assert {:error, :invalid_data} = Compound.calculate(raw_calculation_data)
    end
  end
end
