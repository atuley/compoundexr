defmodule CompoundexrWeb.CompoundLiveTest do
  use CompoundexrWeb.ConnCase

  import Phoenix.LiveViewTest
  import Compoundexr.AccountsFixtures
  import Money.Sigils
  alias Compoundexr.Compound.Result
  alias Compoundexr.Compound.Calculator
  alias Compoundexr.Compound.CalculationData

  defp log_in(context) do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(context.conn, user)}
  end

  describe "Index" do
    setup [:log_in]

    test "calculates and displays compound interest over specified", %{conn: conn} do
      %Result{years: compounded_years, final_balance: final_balance} =
        Calculator.execute(%CalculationData{
          starting_balance: ~M[10000000],
          interest_rate: 0.2,
          years: 20
        })

      {:ok, index_live, _html} = live(conn, ~p"/compound")

      index_live
      |> form("#compound-interest-form")
      |> render_submit(%{
        "calculation_data" => %{
          "starting_balance" => "100000",
          "interest_rate" => "20",
          "years" => "20"
        }
      })

      Enum.map(compounded_years, fn {_year, data} ->
        assert has_element?(index_live, "span", Money.to_string(data.balance))
      end)

      assert has_element?(index_live, "#final-balance", Money.to_string(final_balance))
    end

    test "returns error when calculation data is invalid", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/compound")

      index_live
      |> form("#compound-interest-form")
      |> render_submit(%{
        "calculation_data" => %{
          "starting_balance" => "100000",
          "interest_rate" => "20",
          "years" => "0"
        }
      })

      assert has_element?(index_live, "#flash", "Please correct errors in calculation data.")
    end
  end
end
