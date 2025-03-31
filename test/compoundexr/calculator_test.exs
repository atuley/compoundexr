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
        contribution_growth_rate: 0,
        tax_rate: 0
      }

      assert %Result{
               years: [
                 %CompoundedYear{year: 1, balance: ~M[12000000]},
                 %CompoundedYear{year: 2, balance: ~M[14400000]},
                 %CompoundedYear{year: 3, balance: ~M[17280000]},
                 %CompoundedYear{year: 4, balance: ~M[20736000]},
                 %CompoundedYear{year: 5, balance: ~M[24883200]},
                 %CompoundedYear{year: 6, balance: ~M[29859840]},
                 %CompoundedYear{year: 7, balance: ~M[35831808]},
                 %CompoundedYear{year: 8, balance: ~M[42998170]},
                 %CompoundedYear{year: 9, balance: ~M[51597804]},
                 %CompoundedYear{year: 10, balance: ~M[61917365]},
                 %CompoundedYear{year: 11, balance: ~M[74300838]},
                 %CompoundedYear{year: 12, balance: ~M[89161006]},
                 %CompoundedYear{year: 13, balance: ~M[106993207]},
                 %CompoundedYear{year: 14, balance: ~M[128391848]},
                 %CompoundedYear{year: 15, balance: ~M[154070218]},
                 %CompoundedYear{year: 16, balance: ~M[184884262]},
                 %CompoundedYear{year: 17, balance: ~M[221861114]},
                 %CompoundedYear{year: 18, balance: ~M[266233337]},
                 %CompoundedYear{year: 19, balance: ~M[319480004]},
                 %CompoundedYear{year: 20, balance: ~M[383376005]}
               ],
               final_balance: ~M[383376005],
               final_contribution: ~M[0],
               return_after_taxes: 0.20000000062601728
             } = Calculator.execute(calculation_data)
    end

    test "calculates return after taxes correctly" do
      calculation_data = %CalculationData{
        starting_balance: ~M[10000000],
        interest_rate: 0.20,
        years: 1,
        contributions: ~M[0],
        contribution_growth_rate: 0,
        tax_rate: 0.3
      }

      assert %Result{
               return_after_taxes: 0.14,
               years: [
                 %CompoundedYear{
                   year: 1,
                   balance: ~M[11400000],
                   interest: ~M[2000000],
                   taxes: ~M[600000],
                   contributions: ~M[0]
                 }
               ]
             } = Calculator.execute(calculation_data)
    end

    test "calculates balance with contributions and tax" do
      calculation_data = %CalculationData{
        starting_balance: ~M[10000000],
        interest_rate: 0.20,
        years: 20,
        contributions: ~M[2000000],
        contribution_growth_rate: 0.03,
        tax_rate: 0.3
      }

      assert %Result{
               final_balance: ~M[354478139],
               final_contribution: ~M[3_507_011],
               return_after_taxes: 0.13999999824600956,
               years: [
                 %CompoundedYear{
                   balance: ~M[13400000],
                   contributions: ~M[2000000],
                   interest: ~M[2000000],
                   taxes: ~M[600000],
                   year: 1
                 },
                 %CompoundedYear{
                   balance: ~M[17336000],
                   contributions: ~M[2060000],
                   interest: ~M[2680000],
                   taxes: ~M[804000],
                   year: 2
                 },
                 %CompoundedYear{
                   balance: ~M[21884840],
                   contributions: ~M[2121800],
                   interest: ~M[3467200],
                   taxes: ~M[1040160],
                   year: 3
                 },
                 %CompoundedYear{
                   balance: ~M[27134172],
                   contributions: ~M[2185454],
                   interest: ~M[4376968],
                   taxes: ~M[1313090],
                   year: 4
                 },
                 %CompoundedYear{
                   balance: ~M[33183974],
                   contributions: ~M[2251018],
                   interest: ~M[5426834],
                   taxes: ~M[1628050],
                   year: 5
                 },
                 %CompoundedYear{
                   balance: ~M[40148279],
                   contributions: ~M[2318549],
                   interest: ~M[6636795],
                   taxes: ~M[1991039],
                   year: 6
                 },
                 %CompoundedYear{
                   balance: ~M[48157143],
                   contributions: ~M[2388105],
                   interest: ~M[8029656],
                   taxes: ~M[2408897],
                   year: 7
                 },
                 %CompoundedYear{
                   balance: ~M[57358891],
                   contributions: ~M[2459748],
                   interest: ~M[9631429],
                   taxes: ~M[2889429],
                   year: 8
                 },
                 %CompoundedYear{
                   balance: ~M[67922676],
                   contributions: ~M[2533540],
                   interest: ~M[11471778],
                   taxes: ~M[3441533],
                   year: 9
                 },
                 %CompoundedYear{
                   balance: ~M[80041396],
                   contributions: ~M[2609546],
                   interest: ~M[13584535],
                   taxes: ~M[4075361],
                   year: 10
                 },
                 %CompoundedYear{
                   balance: ~M[93935023],
                   contributions: ~M[2687832],
                   interest: ~M[16008279],
                   taxes: ~M[4802484],
                   year: 11
                 },
                 %CompoundedYear{
                   balance: ~M[109854393],
                   contributions: ~M[2768467],
                   interest: ~M[18787005],
                   taxes: ~M[5636102],
                   year: 12
                 },
                 %CompoundedYear{
                   balance: ~M[128085529],
                   contributions: ~M[2851521],
                   interest: ~M[21970879],
                   taxes: ~M[6591264],
                   year: 13
                 },
                 %CompoundedYear{
                   balance: ~M[148954570],
                   contributions: ~M[2937067],
                   interest: ~M[25617106],
                   taxes: ~M[7685132],
                   year: 14
                 },
                 %CompoundedYear{
                   balance: ~M[172833389],
                   contributions: ~M[3025179],
                   interest: ~M[29790914],
                   taxes: ~M[8937274],
                   year: 15
                 },
                 %CompoundedYear{
                   balance: ~M[200145998],
                   contributions: ~M[3115934],
                   interest: ~M[34566678],
                   taxes: ~M[10370003],
                   year: 16
                 },
                 %CompoundedYear{
                   balance: ~M[231375850],
                   contributions: ~M[3209412],
                   interest: ~M[40029200],
                   taxes: ~M[12008760],
                   year: 17
                 },
                 %CompoundedYear{
                   balance: ~M[267074163],
                   contributions: ~M[3305694],
                   interest: ~M[46275170],
                   taxes: ~M[13882551],
                   year: 18
                 },
                 %CompoundedYear{
                   balance: ~M[307869411],
                   contributions: ~M[3404865],
                   interest: ~M[53414833],
                   taxes: ~M[16024450],
                   year: 19
                 },
                 %CompoundedYear{
                   balance: ~M[354478139],
                   contributions: ~M[3507011],
                   interest: ~M[61573882],
                   taxes: ~M[18472165],
                   year: 20
                 }
               ]
             } = Calculator.execute(calculation_data)
    end
  end
end
