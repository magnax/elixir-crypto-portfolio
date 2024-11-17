defmodule CryptoPortfolioWeb.CoinLive.FormComponent do
  use CryptoPortfolioWeb, :live_component

  alias CryptoPortfolio.Coins

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage coin records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="coin-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:symbol]} type="text" label="Symbol" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Coin</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{coin: coin} = assigns, socket) do
    changeset = Coins.change_coin(coin)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"coin" => coin_params}, socket) do
    changeset =
      socket.assigns.coin
      |> Coins.change_coin(coin_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"coin" => coin_params}, socket) do
    save_coin(socket, socket.assigns.action, coin_params)
  end

  defp save_coin(socket, :edit, coin_params) do
    case Coins.update_coin(socket.assigns.coin, coin_params) do
      {:ok, coin} ->
        notify_parent({:saved, coin})

        {:noreply,
         socket
         |> put_flash(:info, "Coin updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_coin(socket, :new, coin_params) do
    case Coins.create_coin(coin_params) do
      {:ok, coin} ->
        notify_parent({:saved, coin})

        {:noreply,
         socket
         |> put_flash(:info, "Coin created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
