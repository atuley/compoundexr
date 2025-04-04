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

    test "shows create asset link when user has no assets", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/compound")

      assert html =~ "No assets found"
      assert html =~ "Create a New Asset"
      assert html =~ ~p"/assets/new"
    end

    test "calculates and displays compound interest over specified", %{conn: conn} do
      %Result{years: compounded_years, final_balance: final_balance} =
        Calculator.execute(%CalculationData{
          starting_balance: ~M[10000000],
          interest_rate: 0.2,
          years: 20,
          contributions: ~M[0],
          contribution_growth_rate: 0,
          tax_rate: 0
        })

      {:ok, index_live, _html} = live(conn, ~p"/compound")

      index_live
      |> form("#compound-interest-form")
      |> render_submit(%{
        "calculation_data" => %{
          "starting_balance" => "100000",
          "interest_rate" => "20",
          "years" => "20",
          "contributions" => "0",
          "contribution_growth_rate" => "0",
          "tax_rate" => "0"
        }
      })

      Enum.map(compounded_years, fn year ->
        assert has_element?(index_live, "#balance-#{year.year}", Money.to_string(year.balance))
        assert has_element?(index_live, "#interest-#{year.year}", Money.to_string(year.interest))
        assert has_element?(index_live, "#taxes-#{year.year}", Money.to_string(year.taxes))

        assert has_element?(
                 index_live,
                 "#gain-after-taxes-#{year.year}",
                 Money.to_string(Money.subtract(year.interest, year.taxes))
               )

        assert has_element?(
                 index_live,
                 "#contributions-#{year.year}",
                 Money.to_string(year.contributions)
               )
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

    test "displays validation errors for invalid money amounts", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/compound")
      # Test negative contributions
      index_live
      |> form("#compound-interest-form")
      |> render_change(%{
        "calculation_data" => %{
          "starting_balance" => "100000",
          "interest_rate" => "20",
          "years" => "20",
          "contributions" => "-100",
          "contribution_growth_rate" => "0",
          "tax_rate" => "0"
        }
      })

      assert render(index_live) =~ "must be greater than or equal to 0"

      # Test contributions over 1 billion
      index_live
      |> form("#compound-interest-form")
      |> render_change(%{
        "calculation_data" => %{
          "starting_balance" => "100000",
          "interest_rate" => "20",
          "years" => "20",
          "contributions" => "1000000001",
          "contribution_growth_rate" => "0",
          "tax_rate" => "0"
        }
      })

      assert render(index_live) =~ "must be less than or equal to 1,000,000,000"
    end
  end
end
