defmodule Compoundexr.Compound.Calculator do
  alias Money
  alias Compoundexr.Compound.{CalculationData, CompoundedYear, Result}
  import Money.Sigils

  def execute(%CalculationData{
        starting_balance: starting_balance,
        interest_rate: interest_rate,
        years: years,
        contributions: starting_contributions,
        contribution_growth_rate: contribution_growth_rate,
        tax_rate: tax_rate
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
        taxes = Money.multiply(annual_interest, tax_rate)

        interest_after_taxes = Money.subtract(annual_interest, taxes)

        annual_contributions_growth =
          if year == 1 do
            ~M[0]
          else
            Money.multiply(running_contributions, contribution_growth_rate)
          end

        annual_contributions = Money.add(running_contributions, annual_contributions_growth)
        return_after_taxes = interest_after_taxes.amount / running_account_balance.amount

        growth = Money.add(interest_after_taxes, annual_contributions)
        balance = Money.add(running_account_balance, growth)

        %Result{
          years:
            years ++
              [
                %CompoundedYear{
                  year: year,
                  balance: balance,
                  interest: annual_interest,
                  contributions: annual_contributions,
                  taxes: taxes
                }
              ],
          final_balance: balance,
          final_contribution: annual_contributions,
          return_after_taxes: return_after_taxes
        }
      end
    )
  end
end
