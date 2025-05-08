defmodule FitnessWeb.Schema do
  use Absinthe.Schema

  import Absinthe.Resolution.Helpers

  alias Fitness.Exercises.Exercise
  alias Fitness.Exercises
  alias Fitness.WorkoutTemplates.WorkoutTemplate
  alias Fitness.WorkoutTemplates
  alias Fitness.Repo

  require Logger

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(
        :exercises,
        Dataloader.Ecto.new(Repo, query: query_with_logging(&Exercises.query/2))
      )
      |> Dataloader.add_source(
        :workout_templates,
        Dataloader.Ecto.new(Repo, query: query_with_logging(&WorkoutTemplates.query/2))
      )

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

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
      if Application.compile_env(:fitness, :use_dataloader, false) do
        resolve(dataloader(:exercises, :exercise))
      else
        resolve(fn workout_item, _, _ ->
          {:ok, Repo.get(Exercise, workout_item.exercise_id)}
        end)
      end
    end
  end

  object :workout_template do
    field :id, non_null(:id)
    field :name, :string
    field :workout_template_score, :integer
    field :is_finished, :boolean

    field :workout_items, list_of(:workout_item) do
      if Application.compile_env(:fitness, :use_dataloader, false) do
        resolve(dataloader(:workout_templates, :workout_items))
      else
        resolve(fn workout_template, _, _ ->
          {:ok, WorkoutTemplates.fetch_workout_items_by_workout_template(workout_template)}
        end)
      end
    end
  end

  input_object :workout_template_get_input do
    field :workout_template_id, non_null(:integer)
  end

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
      arg(:input, type: non_null(:workout_template_get_input))

      resolve(fn _, %{input: %{workout_template_id: workout_template_id}}, _res ->
        {:ok, Fitness.WorkoutTemplates.get_workout_template!(workout_template_id)}
      end)
    end
  end

  def query_with_logging(query_fun) do
    fn queryable, args ->
      query = query_fun.(queryable, args)
      {sql, params} = Ecto.Adapters.SQL.to_sql(:all, Repo, query)
      Logger.error("Dataloader SQL: #{sql} with params #{inspect(params)}")
      query
    end
  end
end
