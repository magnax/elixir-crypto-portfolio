defmodule CryptoPortfolio.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :name, :string
      add :symbol, :string

      timestamps()
    end
  end
end
