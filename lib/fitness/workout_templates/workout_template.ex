defmodule Fitness.WorkoutTemplates.WorkoutTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workout_templates" do
    field :name, :string
    field :workout_template_score, :integer, default: 0
    field :is_finished, :boolean, default: false
    belongs_to :user, Fitness.Accounts.User
    has_many :workout_items, Fitness.WorkoutTemplates.WorkoutItem

    timestamps()
  end

  @doc false
  def changeset(workout_template, attrs) do
    workout_template
    |> cast(attrs, [:name, :user_id, :workout_template_score, :is_finished])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
    |> cast_assoc(:workout_items)
  end
end
