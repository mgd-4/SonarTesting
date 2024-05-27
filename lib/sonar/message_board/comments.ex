defmodule Sonar.MessageBoard.Comments do
  import Ecto.Query, warn: false
  alias Sonar.Repo

  alias Sonar.MessageBoard.Comment
  alias Sonar.MessageBoard.Post

  @spec list_comments_by_post_id(integer()) :: [%Comment{}]
  def list_comments_by_post_id(post_id) do
    Repo.all(from c in Comment, where: c.post_id == ^post_id, order_by: [desc: c.inserted_at])
  end

  @spec list_comments() :: [%Comment{}]
  def list_comments do
    Repo.all(from(c in Comment))
  end

  @spec get_comment!(integer()) :: nil | %Comment{}
  def get_comment!(id), do: Comment |> Repo.get!(id) |> Repo.preload(:post)

  @spec create_comment(%Post{}, map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_comment(%Post{} = post, attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.put_change(:post_id, post.id)
    |> Repo.insert()
  end

  @spec update_comment(%Comment{}, map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_comment(%Comment{}) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @spec change_comment(%Comment{}) :: Ecto.Changeset.t()
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
