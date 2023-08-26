defmodule Compoundexr.CompoundTest do
  use Compoundexr.DataCase

  alias Compoundexr.Compound.Result
  alias Compoundexr.Compound

  describe "calculate/1" do
    test "returns calculation with valid calulation data" do
      raw_calculation_data = %{
        "starting_balance" => "10000000",
        "interest_rate" => "20",
        "years" => "20"
      }

      assert {:ok, %Result{}} = Compound.calculate(raw_calculation_data)
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
