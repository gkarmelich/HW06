defmodule TaskTracker.Task.Tracker do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Task.Tracker


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :name, :string
    field :time, :integer
    belongs_to :user, TaskTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Tracker{} = tracker, attrs) do
    tracker
    |> cast(attrs, [:completed, :description, :time, :name, :user_id])
    |> validate_required([:completed, :description, :time, :name, :user_id])
  end
end
