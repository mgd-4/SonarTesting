defmodule SonarWeb.PostLive.Index do
  use SonarWeb, :live_view

  alias Sonar.MessageBoard
  alias Sonar.MessageBoard.Post

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(:sonar_pubsub, "posts")
    {:ok, stream(socket, :posts, MessageBoard.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, MessageBoard.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({:new, post}, socket) do
    post = MessageBoard.get_post!(post.id)

    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  @impl true
  def handle_info({SonarWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    post_preload = MessageBoard.get_post!(post.id)
    {:noreply, stream_insert(socket, :posts, post_preload, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = MessageBoard.get_post!(id)
    {:ok, _} = MessageBoard.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  def count_comments(comment_list), do: Enum.count(comment_list)
end
