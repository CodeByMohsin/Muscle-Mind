defmodule FitnessWeb.Schema do
  use Absinthe.Schema

  alias Fitness.Exercises.Exercise
  alias Fitness.WorkoutTemplates.WorkoutTemplate

  # Query entry point
  query do
    @desc "List all exercises"
    field :exercises, list_of(:exercise) do
      resolve(fn _, _, _ ->
        {:ok, Fitness.Repo.all(Exercise)}
      end)
    end

    @desc "List all workout templates"
    field :workout_templates, list_of(:workout_template) do
      resolve(fn _, _, _ ->
        {:ok, Fitness.Repo.all(WorkoutTemplate)}
      end)
    end

    @desc "Fetch a specific workout template"
    field :get_workout_template, :workout_template do
      resolve(fn workout_template, _, _ ->
        {:ok,
         Fitness.WorkoutTemplates.fetch_workout_items_by_workout_template(workout_template.id)}
      end)
    end
  end

  # Types
  object :exercise do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :type, :string
    field :level, :string
    field :description, :string
    field :body_part, :string
    field :equipment, :string
  end

  object :workout_item do
    field :id, non_null(:id)
    field :sets, :integer
    field :reps, :integer
    field :weight, :float
    field :weight_unit, :string

    field :exercise, :exercise do
      resolve(fn workout_item, _, _ ->
        {:ok, Fitness.Repo.get(Exercise, workout_item.exercise_id)}
      end)
    end
  end

  object :workout_template do
    field :id, non_null(:id)
    field :name, :string
    field :workout_template_score, :integer
    field :is_finished, :boolean

    field :workout_items, list_of(:workout_item) do
      resolve(fn workout_template, _, _ ->
        {:ok, Fitness.WorkoutTemplates.fetch_workout_items_by_workout_template(workout_template)}
      end)
    end
  end
end
