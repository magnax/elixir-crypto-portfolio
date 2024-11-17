defmodule CryptoPortfolioWeb.CoinLive.Index do
  use CryptoPortfolioWeb, :live_view

  alias CryptoPortfolio.Coins
  alias CryptoPortfolio.Coins.Coin

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :coins, Coins.list_coins())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Coin")
    |> assign(:coin, Coins.get_coin!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Coin")
    |> assign(:coin, %Coin{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Coins")
    |> assign(:coin, nil)
  end

  @impl true
  def handle_info({CryptoPortfolioWeb.CoinLive.FormComponent, {:saved, coin}}, socket) do
    {:noreply, stream_insert(socket, :coins, coin)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    coin = Coins.get_coin!(id)
    {:ok, _} = Coins.delete_coin(coin)

    {:noreply, stream_delete(socket, :coins, coin)}
  end
end
