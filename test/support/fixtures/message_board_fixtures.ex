defmodule Sonar.MessageBoardFixtures do
  alias Sonar.Repo

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sonar.MessageBoard` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        body: "some body"
      })

    {:ok, post} =
      Sonar.MessageBoard.Post.changeset(%Sonar.MessageBoard.Post{}, attrs) |> Repo.insert()

    post |> Repo.preload([:comments])
  end
end
