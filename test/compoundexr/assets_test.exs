defmodule Compoundexr.AssetsTest do
  use Compoundexr.DataCase
  import Compoundexr.AccountsFixtures
  import Compoundexr.AssetsFixtures
  import Money.Sigils

  alias Compoundexr.Assets

  describe "assets" do
    alias Compoundexr.Assets.Asset

    @invalid_attrs %{name: nil, balance: nil}

    test "list_assets/0 returns all assets" do
      user = user_fixture()
      other_user = user_fixture()
      asset = asset_fixture(%{user: user})
      asset_fixture(%{user: other_user})
      assert Assets.list_assets(user.id) == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture(%{user: user_fixture()})
      assert Assets.get_asset!(asset.id) == asset
    end

    test "create_asset/1 with valid data creates a asset" do
      valid_attrs = %{name: "some name", balance: 42, user_id: user_fixture().id}

      assert {:ok, %Asset{} = asset} = Assets.create_asset(valid_attrs)
      assert asset.name == "some name"
      assert asset.balance == ~M[42]
    end

    test "create_asset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_asset(@invalid_attrs)
    end

    test "update_asset/2 with valid data updates the asset" do
      asset = asset_fixture(%{user: user_fixture()})
      update_attrs = %{name: "some updated name", balance: 43}

      assert {:ok, %Asset{} = asset} = Assets.update_asset(asset, update_attrs)
      assert asset.name == "some updated name"
      assert asset.balance == ~M[43]
    end

    test "update_asset/2 with invalid data returns error changeset" do
      asset = asset_fixture(%{user: user_fixture()})
      assert {:error, %Ecto.Changeset{}} = Assets.update_asset(asset, @invalid_attrs)
      assert asset == Assets.get_asset!(asset.id)
    end

    test "delete_asset/1 deletes the asset" do
      asset = asset_fixture(%{user: user_fixture()})
      assert {:ok, %Asset{}} = Assets.delete_asset(asset)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_asset!(asset.id) end
    end

    test "change_asset/1 returns a asset changeset" do
      asset = asset_fixture(%{user: user_fixture()})
      assert %Ecto.Changeset{} = Assets.change_asset(asset)
    end
  end
end
