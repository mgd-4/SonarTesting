defmodule Sonar.MessageBoard do
  @moduledoc """
  The MessageBoard context.
  """

  # import Ecto.Query, warn: false
  # alias Sonar.Repo

  alias Sonar.MessageBoard.Comments
  alias Sonar.MessageBoard.Posts

  defdelegate list_posts, to: Posts
  defdelegate get_post!(id), to: Posts
  defdelegate create_post(), to: Posts
  defdelegate create_post(attrs), to: Posts
  defdelegate update_post(post, attrs), to: Posts
  defdelegate delete_post(post), to: Posts
  defdelegate change_post(post), to: Posts
  defdelegate change_post(post, attrs), to: Posts

  defdelegate list_comments, to: Comments
  defdelegate list_comments_by_post_id(post_id), to: Comments
  defdelegate get_comment!(id), to: Comments
  defdelegate create_comment(post), to: Comments
  defdelegate create_comment(post, attrs), to: Comments
  defdelegate update_comment(comment, attrs), to: Comments
  defdelegate delete_comment(comment), to: Comments
  defdelegate change_comment(comment), to: Comments
  defdelegate change_comment(comment, attrs), to: Comments
end
