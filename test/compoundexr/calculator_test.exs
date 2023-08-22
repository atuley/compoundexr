defmodule Compoundexr.CalculatorTest do
  use Compoundexr.DataCase

  import Money.Sigils

  alias Compoundexr.Compound.Calculator
  alias Compoundexr.Compound.{CalculationData, CompoundedYear, Result}

  describe "execute/1" do
    test "calculates balance after specified number of years" do
      calculation_data = %CalculationData{
        starting_balance: ~M[10000000],
        interest_rate: 0.20,
        years: 20
      }

      assert %Result{
               years: %{
                 1 => %CompoundedYear{year: 1, balance: ~M[12000000]},
                 2 => %CompoundedYear{year: 2, balance: ~M[14400000]},
                 3 => %CompoundedYear{year: 3, balance: ~M[17280000]},
                 4 => %CompoundedYear{year: 4, balance: ~M[20736000]},
                 5 => %CompoundedYear{year: 5, balance: ~M[24883200]},
                 6 => %CompoundedYear{year: 6, balance: ~M[29859840]},
                 7 => %CompoundedYear{year: 7, balance: ~M[35831808]},
                 8 => %CompoundedYear{year: 8, balance: ~M[42998170]},
                 9 => %CompoundedYear{year: 9, balance: ~M[51597804]},
                 10 => %CompoundedYear{year: 10, balance: ~M[61917365]},
                 11 => %CompoundedYear{year: 11, balance: ~M[74300838]},
                 12 => %CompoundedYear{year: 12, balance: ~M[89161006]},
                 13 => %CompoundedYear{year: 13, balance: ~M[106993207]},
                 14 => %CompoundedYear{year: 14, balance: ~M[128391848]},
                 15 => %CompoundedYear{year: 15, balance: ~M[154070218]},
                 16 => %CompoundedYear{year: 16, balance: ~M[184884262]},
                 17 => %CompoundedYear{year: 17, balance: ~M[221861114]},
                 18 => %CompoundedYear{year: 18, balance: ~M[266233337]},
                 19 => %CompoundedYear{year: 19, balance: ~M[319480004]},
                 20 => %CompoundedYear{year: 20, balance: ~M[383376005]}
               },
               final_balance: ~M[383376005]
             } == Calculator.execute(calculation_data)
    end
  end
end
