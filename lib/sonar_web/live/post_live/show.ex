defmodule SonarWeb.PostLive.Show do
  use SonarWeb, :live_view

  alias Sonar.MessageBoard
  alias Sonar.MessageBoard.Comment

  @impl true
  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(:sonar_pubsub, "comments")
    {:ok, stream(socket, :comments, MessageBoard.list_comments_by_post_id(params["id"]))}
  end

  def handle_params(
        %{"id" => id, "post_id" => post_id},
        _,
        %{assigns: %{live_action: :edit_comment}} = socket
      ) do
    post = MessageBoard.get_post!(post_id)
    comment = MessageBoard.get_comment!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment, comment)
     |> assign(:post, post)}
  end

  # create new comment
  def handle_params(%{"post_id" => post_id}, _, socket) do
    post = MessageBoard.get_post!(post_id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment, %Comment{})
     |> assign(:post, post)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, MessageBoard.get_post!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = MessageBoard.get_comment!(id)
    {:ok, _} = MessageBoard.delete_comment(comment)

    {:noreply, stream_delete(socket, :comments, comment)}
  end

  @impl true
  def handle_info({:new, comment}, socket) do
    {:noreply, stream_insert(socket, :comments, comment, at: 0)}
  end

  @impl true
  def handle_info({SonarWeb.PostLive.FormComponent, {:saved, comment}}, socket) do
    {:noreply, stream_insert(socket, :comments, comment, at: 0)}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"

  defp page_title(:new_comment), do: "Add Comment"
  defp page_title(:edit_comment), do: "Edit Comment"
end
