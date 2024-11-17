defmodule CryptoPortfolio.Repo do
  use Ecto.Repo,
    otp_app: :crypto_portfolio,
    adapter: Ecto.Adapters.Postgres
end
