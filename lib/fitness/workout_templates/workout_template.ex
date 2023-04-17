defmodule Fitness.WorkoutTemplates.WorkoutTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workout_templates" do
    field :name, :string
    belongs_to :user, Fitness.Accounts.User
    has_many :workout_items, Fitness.WorkoutTemplates.WorkoutItem

    timestamps()
  end

  @doc false
  def changeset(workout_template, attrs) do
    workout_template
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
