defmodule Compoundexr.Compound.Calculator do
  alias Money
  alias Compoundexr.Compound.{CalculationData, CompoundedYear, Result}

  def execute(%CalculationData{
        starting_balance: starting_balance,
        interest_rate: interest_rate,
        years: years
      }) do
    Enum.reduce(1..years, %Result{final_balance: starting_balance}, fn year,
                                                                       %Result{
                                                                         years: years,
                                                                         final_balance:
                                                                           running_account_balance
                                                                       } ->
      annual_interest = Money.multiply(running_account_balance, interest_rate)
      balance = Money.add(running_account_balance, annual_interest)

      %Result{
        years: Map.put(years, year, %CompoundedYear{year: year, balance: balance}),
        final_balance: balance
      }
    end)
  end
end
