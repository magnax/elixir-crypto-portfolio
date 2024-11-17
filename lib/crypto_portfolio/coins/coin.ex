defmodule CryptoPortfolio.Coins.Coin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coins" do
    field :name, :string
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :symbol])
    |> validate_required([:name, :symbol])
  end
end
