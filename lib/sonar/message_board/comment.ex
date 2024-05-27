defmodule Sonar.MessageBoard.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    belongs_to :post, Sonar.MessageBoard.Post
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id])
    |> validate_required([:body, :post_id])
    |> assoc_constraint(:post)
    |> validate_length(:body, min: 1, max: 255)
  end
end
