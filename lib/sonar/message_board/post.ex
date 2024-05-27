defmodule Sonar.MessageBoard.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string

    has_many :comments, Sonar.MessageBoard.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 1, max: 255)
  end
end
