defmodule SonarWeb.PostLive.FormComponent do
  use SonarWeb, :live_component

  alias Sonar.MessageBoard

  @impl true
  def render(%{post: _post} = assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Type your post here!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="textarea" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def render(%{comment: _comment} = assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this to leave a comment!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="textarea" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = MessageBoard.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = MessageBoard.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> MessageBoard.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> MessageBoard.change_comment(comment_params |> Map.put("post_id", socket.assigns.post_id))
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_post(socket, :edit, post_params) do
    case MessageBoard.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})
        Phoenix.PubSub.broadcast(:sonar_pubsub, "posts", {:new, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    case MessageBoard.create_post(post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})
        Phoenix.PubSub.broadcast(:sonar_pubsub, "posts", {:new, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :edit_comment, comment_params) do
    case MessageBoard.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})
        Phoenix.PubSub.broadcast(:sonar_pubsub, "comments", {:new, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new_comment, comment_params) do
    post = MessageBoard.get_post!(socket.assigns.post_id)

    case MessageBoard.create_comment(post, comment_params |> Map.put("post_id", post.id)) do
      {:ok, comment} ->
        notify_parent({:saved, comment})
        Phoenix.PubSub.broadcast(:sonar_pubsub, "comments", {:new, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
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
