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
    # Create initial result
    initial_result = %Result{
      final_balance: starting_balance,
      final_contribution: starting_contributions
    }

    # Process each year
    Enum.reduce(1..years, initial_result, fn year, result_acc ->
      process_year(
        year,
        result_acc,
        interest_rate,
        contribution_growth_rate,
        tax_rate
      )
    end)
  end

  # Process a single year of calculations
  defp process_year(
         year,
         %Result{final_balance: balance, final_contribution: contributions} = result_acc,
         interest_rate,
         contribution_growth_rate,
         tax_rate
       ) do
    # Calculate interest and taxes
    interest = Money.multiply(balance, interest_rate)
    taxes = Money.multiply(interest, tax_rate)
    interest_after_taxes = Money.subtract(interest, taxes)

    # Calculate contributions
    contribution_growth =
      if year == 1 do
        ~M[0]
      else
        Money.multiply(contributions, contribution_growth_rate)
      end

    updated_contributions = Money.add(contributions, contribution_growth)

    # Calculate return and growth
    return_after_taxes = interest_after_taxes.amount / balance.amount
    growth = Money.add(interest_after_taxes, updated_contributions)

    # Calculate updated balance
    updated_balance = Money.add(balance, growth)

    # Create compounded year record
    compounded_year = %CompoundedYear{
      year: year,
      balance: updated_balance,
      interest: interest,
      contributions: updated_contributions,
      taxes: taxes
    }

    # Update result
    %Result{
      result_acc
      | years: result_acc.years ++ [compounded_year],
        final_balance: updated_balance,
        final_contribution: updated_contributions,
        return_after_taxes: return_after_taxes
    }
  end
end
