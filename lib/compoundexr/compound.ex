defmodule Compoundexr.Compound do
  alias Compoundexr.Compound.CalculationData
  alias Compoundexr.Compound.Calculator

  def change_calculation_data(calculation_data \\ %CalculationData{}, params) do
    calculation_data
    |> CalculationData.changeset(params)
    |> Map.put(:action, :validate)
  end

  def calculate(params) do
    case CalculationData.changeset(params) do
      %{valid?: true} = changeset ->
        {:ok, run_calculation(changeset)}

      _changeset ->
        {:error, :invalid_data}
    end
  end

  defp run_calculation(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes()
    |> convert_interest_rate()
    |> convert_contribution_growth_rate()
    |> convert_tax_rate()
    |> Calculator.execute()
    |> format_tax_adjusted_return()
  end

  defp convert_interest_rate(
         %CalculationData{interest_rate: raw_interest_rate} = calculation_data
       ) do
    %CalculationData{calculation_data | interest_rate: raw_interest_rate / 100}
  end

  defp convert_contribution_growth_rate(
         %CalculationData{contribution_growth_rate: raw_contribution_growth_rate} =
           calculation_data
       ) do
    %CalculationData{
      calculation_data
      | contribution_growth_rate: raw_contribution_growth_rate / 100
    }
  end

  defp convert_tax_rate(
         %CalculationData{tax_rate: raw_tax_rate} =
           calculation_data
       ) do
    %CalculationData{
      calculation_data
      | tax_rate: raw_tax_rate / 100
    }
  end

  defp format_tax_adjusted_return(result) do
    %{result | return_after_taxes: format_decimal(result.return_after_taxes)}
  end

  defp format_decimal(value) do
    value
    |> Decimal.from_float()
    |> Decimal.round(4)
    |> Decimal.mult(100)
    |> Decimal.round(2)
    |> Decimal.to_string()
  end
end
