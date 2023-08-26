defmodule CompoundexrWeb.CompoundLiveTest do
  use CompoundexrWeb.ConnCase

  import Phoenix.LiveViewTest
  import Compoundexr.AccountsFixtures

  defp log_in(context) do
    password = valid_user_password()
    user = user_fixture(%{password: password})
    %{conn: log_in_user(context.conn, user)}
  end

  describe "Index" do
    setup [:log_in]

    test "calculates and displays compound interest over specified", %{conn: conn} do
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

      assert has_element?(index_live, "#final-balance", "$3,833,760.05")
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
