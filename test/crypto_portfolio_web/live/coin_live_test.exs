defmodule CryptoPortfolioWeb.CoinLiveTest do
  use CryptoPortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import CryptoPortfolio.CoinsFixtures

  @create_attrs %{name: "some name", symbol: "some symbol"}
  @update_attrs %{name: "some updated name", symbol: "some updated symbol"}
  @invalid_attrs %{name: nil, symbol: nil}

  defp create_coin(_) do
    coin = coin_fixture()
    %{coin: coin}
  end

  describe "Index" do
    setup [:create_coin]

    test "lists all coins", %{conn: conn, coin: coin} do
      {:ok, _index_live, html} = live(conn, ~p"/coins")

      assert html =~ "Listing Coins"
      assert html =~ coin.name
    end

    test "saves new coin", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/coins")

      assert index_live |> element("a", "New Coin") |> render_click() =~
               "New Coin"

      assert_patch(index_live, ~p"/coins/new")

      assert index_live
             |> form("#coin-form", coin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#coin-form", coin: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/coins")

      html = render(index_live)
      assert html =~ "Coin created successfully"
      assert html =~ "some name"
    end

    test "updates coin in listing", %{conn: conn, coin: coin} do
      {:ok, index_live, _html} = live(conn, ~p"/coins")

      assert index_live |> element("#coins-#{coin.id} a", "Edit") |> render_click() =~
               "Edit Coin"

      assert_patch(index_live, ~p"/coins/#{coin}/edit")

      assert index_live
             |> form("#coin-form", coin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#coin-form", coin: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/coins")

      html = render(index_live)
      assert html =~ "Coin updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes coin in listing", %{conn: conn, coin: coin} do
      {:ok, index_live, _html} = live(conn, ~p"/coins")

      assert index_live |> element("#coins-#{coin.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#coins-#{coin.id}")
    end
  end

  describe "Show" do
    setup [:create_coin]

    test "displays coin", %{conn: conn, coin: coin} do
      {:ok, _show_live, html} = live(conn, ~p"/coins/#{coin}")

      assert html =~ "Show Coin"
      assert html =~ coin.name
    end

    test "updates coin within modal", %{conn: conn, coin: coin} do
      {:ok, show_live, _html} = live(conn, ~p"/coins/#{coin}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Coin"

      assert_patch(show_live, ~p"/coins/#{coin}/show/edit")

      assert show_live
             |> form("#coin-form", coin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#coin-form", coin: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/coins/#{coin}")

      html = render(show_live)
      assert html =~ "Coin updated successfully"
      assert html =~ "some updated name"
    end
  end
end
