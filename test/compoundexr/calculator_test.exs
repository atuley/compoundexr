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
        years: 20,
        contributions: ~M[0],
        contribution_growth_rate: 0
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
               final_balance: ~M[383376005],
               final_contribution: ~M[0]
             } = Calculator.execute(calculation_data)
    end

    test "calculates balance with contributions" do
      calculation_data = %CalculationData{
        starting_balance: ~M[10000000],
        interest_rate: 0.20,
        years: 20,
        contributions: ~M[2000000],
        contribution_growth_rate: 0.03
      }

      assert %Result{
               final_balance: ~M[813_158_217],
               final_contribution: ~M[3_507_011],
               years: %{
                 1 => %CompoundedYear{
                   year: 1,
                   balance: ~M[14000000],
                   interest: ~M[2000000],
                   contributions: ~M[2000000]
                 },
                 2 => %CompoundedYear{
                   year: 2,
                   balance: ~M[18860000],
                   interest: ~M[2800000],
                   contributions: ~M[2060000]
                 },
                 3 => %CompoundedYear{
                   year: 3,
                   balance: ~M[24753800],
                   interest: ~M[3772000],
                   contributions: ~M[2121800]
                 },
                 4 => %CompoundedYear{
                   year: 4,
                   balance: ~M[31890014],
                   interest: ~M[4950760],
                   contributions: ~M[2185454]
                 },
                 5 => %CompoundedYear{
                   year: 5,
                   balance: ~M[40519035],
                   interest: ~M[6378003],
                   contributions: ~M[2251018]
                 },
                 6 => %CompoundedYear{
                   year: 6,
                   balance: ~M[50941391],
                   interest: ~M[8103807],
                   contributions: ~M[2318549]
                 },
                 7 => %CompoundedYear{
                   year: 7,
                   balance: ~M[63517774],
                   interest: ~M[10188278],
                   contributions: ~M[2388105]
                 },
                 8 => %CompoundedYear{
                   year: 8,
                   balance: ~M[78681077],
                   interest: ~M[12703555],
                   contributions: ~M[2459748]
                 },
                 9 => %CompoundedYear{
                   year: 9,
                   balance: ~M[96950832],
                   interest: ~M[15736215],
                   contributions: ~M[2533540]
                 },
                 10 => %CompoundedYear{
                   year: 10,
                   balance: ~M[118950544],
                   interest: ~M[19390166],
                   contributions: ~M[2609546]
                 },
                 11 => %CompoundedYear{
                   year: 11,
                   balance: ~M[145428485],
                   interest: ~M[23790109],
                   contributions: ~M[2687832]
                 },
                 12 => %CompoundedYear{
                   year: 12,
                   balance: ~M[177282649],
                   interest: ~M[29085697],
                   contributions: ~M[2768467]
                 },
                 13 => %CompoundedYear{
                   year: 13,
                   balance: ~M[215590700],
                   interest: ~M[35456530],
                   contributions: ~M[2851521]
                 },
                 14 => %CompoundedYear{
                   year: 14,
                   balance: ~M[261645907],
                   interest: ~M[43118140],
                   contributions: ~M[2937067]
                 },
                 15 => %CompoundedYear{
                   year: 15,
                   balance: ~M[317000267],
                   interest: ~M[52329181],
                   contributions: ~M[3025179]
                 },
                 16 => %CompoundedYear{
                   year: 16,
                   balance: ~M[383516254],
                   interest: ~M[63400053],
                   contributions: ~M[3115934]
                 },
                 17 => %CompoundedYear{
                   year: 17,
                   balance: ~M[463428917],
                   interest: ~M[76703251],
                   contributions: ~M[3209412]
                 },
                 18 => %CompoundedYear{
                   year: 18,
                   balance: ~M[559420394],
                   interest: ~M[92685783],
                   contributions: ~M[3305694]
                 },
                 19 => %CompoundedYear{
                   year: 19,
                   balance: ~M[674709338],
                   interest: ~M[111884079],
                   contributions: ~M[3404865]
                 },
                 20 => %CompoundedYear{
                   year: 20,
                   balance: ~M[813158217],
                   interest: ~M[134941868],
                   contributions: ~M[3507011]
                 }
               }
             } = Calculator.execute(calculation_data)
    end
  end
end
