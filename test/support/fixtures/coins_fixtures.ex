defmodule CryptoPortfolio.CoinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CryptoPortfolio.Coins` context.
  """

  @doc """
  Generate a coin.
  """
  def coin_fixture(attrs \\ %{}) do
    {:ok, coin} =
      attrs
      |> Enum.into(%{
        name: "some name",
        symbol: "some symbol"
      })
      |> CryptoPortfolio.Coins.create_coin()

    coin
  end
end
