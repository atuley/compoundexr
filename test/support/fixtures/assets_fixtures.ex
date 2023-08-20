defmodule Compoundexr.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Compoundexr.Assets` context.
  """

  @doc """
  Generate a asset.
  """
  def asset_fixture(attrs \\ %{}) do
    {:ok, asset} =
      attrs
      |> Enum.into(%{
        name: "some name",
        balance: 42,
        user_id: attrs.user.id
      })
      |> Compoundexr.Assets.create_asset()

    asset
  end
end
