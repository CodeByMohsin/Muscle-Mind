defmodule Fitness.WorkoutTemplates do
  @moduledoc """
  The WorkoutTemplates context.
  """

  import Ecto.Query, warn: false
  alias Fitness.Repo

  alias Fitness.WorkoutTemplates.WorkoutTemplate

  @doc """
  Returns the list of workout_templates.

  ## Examples

      iex> list_workout_templates()
      [%WorkoutTemplate{}, ...]

  """
  def list_workout_templates do
    Repo.all(WorkoutTemplate)
  end

  @doc """
  Gets a single workout_template.

  Raises `Ecto.NoResultsError` if the Workout template does not exist.

  ## Examples

      iex> get_workout_template!(123)
      %WorkoutTemplate{}

      iex> get_workout_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workout_template!(id), do: Repo.get!(WorkoutTemplate, id)

  @doc """
  Creates a workout_template.

  ## Examples

      iex> create_workout_template(%{field: value})
      {:ok, %WorkoutTemplate{}}

      iex> create_workout_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workout_template(attrs \\ %{}) do
    %WorkoutTemplate{}
    |> WorkoutTemplate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workout_template.

  ## Examples

      iex> update_workout_template(workout_template, %{field: new_value})
      {:ok, %WorkoutTemplate{}}

      iex> update_workout_template(workout_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workout_template(%WorkoutTemplate{} = workout_template, attrs) do
    workout_template
    |> WorkoutTemplate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a workout_template.

  ## Examples

      iex> delete_workout_template(workout_template)
      {:ok, %WorkoutTemplate{}}

      iex> delete_workout_template(workout_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workout_template(%WorkoutTemplate{} = workout_template) do
    Repo.delete(workout_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workout_template changes.

  ## Examples

      iex> change_workout_template(workout_template)
      %Ecto.Changeset{data: %WorkoutTemplate{}}

  """
  def change_workout_template(%WorkoutTemplate{} = workout_template, attrs \\ %{}) do
    WorkoutTemplate.changeset(workout_template, attrs)
  end
end
