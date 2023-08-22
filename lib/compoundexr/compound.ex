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

      _ ->
        {:error, :invalid_data}
    end
  end

  defp run_calculation(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes()
    |> convert_interest_rate()
    |> Calculator.execute()
  end

  defp convert_interest_rate(
         %CalculationData{interest_rate: raw_interest_rate} = calculation_data
       ) do
    %CalculationData{calculation_data | interest_rate: raw_interest_rate / 100}
  end
end
