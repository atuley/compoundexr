defmodule CompoundexrWeb.CompoundLive.Index do
  use CompoundexrWeb, :live_view

  alias Compoundexr.Assets
  alias Compoundexr.Compound

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_changeset(Compound.change_calculation_data(%{interest_rate: 0, years: 1}))
     |> assign_form()
     |> assign_asset_options()
     |> assign(final_balance: nil)
     |> assign(years: nil)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp assign_changeset(socket, changeset) do
    assign(socket, changeset: changeset)
  end

  defp assign_form(%{assigns: %{changeset: changeset}} = socket) do
    assign(socket, :form, to_form(changeset))
  end

  defp assign_asset_options(socket) do
    asset_options =
      socket.assigns.current_user.id
      |> Assets.list_assets()
      |> Enum.map(&{&1.name, Money.to_string(&1.balance)})

    assign(socket, asset_options: asset_options)
  end

  @impl true
  def handle_event("validate", %{"calculation_data" => params}, socket) do
    {:noreply,
     socket
     |> assign_changeset(Compound.change_calculation_data(params))
     |> assign_form()}
  end

  def handle_event("save", %{"calculation_data" => params}, socket) do
    case Compound.calculate(params) do
      {:ok, result} ->
        {:noreply, assign(socket, final_balance: result.final_balance, years: result.years)}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Please correct errors in calculation data.")
         |> push_patch(to: ~p"/compound")}
    end
  end
end
