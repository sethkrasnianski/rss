defmodule RssWeb.FeedLive.FormComponent do
  use RssWeb, :live_component

  alias Rss.Feeds

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage feed records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="feed-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="title" />
        <.input field={{f, :description}} type="text" label="description" />
        <.input field={{f, :feed_url}} type="text" label="feed_url" />
        <.input field={{f, :icon_url}} type="text" label="icon_url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Feed</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{feed: feed} = assigns, socket) do
    changeset = Feeds.change_feed(feed)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"feed" => feed_params}, socket) do
    changeset =
      socket.assigns.feed
      |> Feeds.change_feed(feed_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"feed" => feed_params}, socket) do
    save_feed(
      socket,
      socket.assigns.action,
      params_with_user(feed_params, socket.assigns.current_user)
    )
  end

  defp save_feed(socket, :edit, feed_params) do
    case Feeds.update_feed(socket.assigns.feed, feed_params) do
      {:ok, _feed} ->
        {:noreply,
         socket
         |> put_flash(:info, "Feed updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_feed(socket, :new, feed_params) do
    case Feeds.create_feed(feed_params) do
      {:ok, _feed} ->
        {:noreply,
         socket
         |> put_flash(:info, "Feed created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp params_with_user(feed_params, user), do: Map.put(feed_params, "user_id", user.id)
end
