defmodule Sonar.MessageBoardTest do
  use Sonar.DataCase

  alias Sonar.MessageBoard

  describe "posts" do
    alias Sonar.MessageBoard.Post

    import Sonar.MessageBoardFixtures

    @invalid_attrs %{body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert MessageBoard.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert MessageBoard.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body"}

      assert {:ok, %Post{} = post} = MessageBoard.create_post(valid_attrs)
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MessageBoard.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Post{} = post} = MessageBoard.update_post(post, update_attrs)
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = MessageBoard.update_post(post, @invalid_attrs)
      assert post == MessageBoard.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = MessageBoard.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> MessageBoard.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = MessageBoard.change_post(post)
    end
  end
end
