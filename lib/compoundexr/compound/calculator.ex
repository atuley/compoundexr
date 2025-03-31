defmodule Compoundexr.Compound.Calculator do
  alias Money
  alias Compoundexr.Compound.{CalculationData, CompoundedYear, Result}
  import Money.Sigils

  def execute(%CalculationData{
        starting_balance: starting_balance,
        interest_rate: interest_rate,
        years: years,
        contributions: starting_contributions,
        contribution_growth_rate: contribution_growth_rate
      }) do
    Enum.reduce(
      1..years,
      %Result{final_balance: starting_balance, final_contribution: starting_contributions},
      fn year,
         %Result{
           years: years,
           final_balance: running_account_balance,
           final_contribution: running_contributions
         } ->
        annual_interest = Money.multiply(running_account_balance, interest_rate)

        annual_contributions_growth =
          if year == 1 do
            ~M[0]
          else
            Money.multiply(running_contributions, contribution_growth_rate)
          end

        annual_contributions = Money.add(running_contributions, annual_contributions_growth)

        growth = Money.add(annual_interest, annual_contributions)
        balance = Money.add(running_account_balance, growth)

        %Result{
          years:
            Map.put(years, year, %CompoundedYear{
              year: year,
              balance: balance,
              interest: annual_interest,
              contributions: annual_contributions
            }),
          final_balance: balance,
          final_contribution: annual_contributions
        }
      end
    )
  end
end
