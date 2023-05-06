defmodule Fitness.WorkoutTemplatesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fitness.WorkoutTemplates` context.
  """

  @doc """
  Generate a workout_template.
  """
  def workout_template_fixture(attrs \\ %{}) do
    {:ok, workout_template} =
      attrs
      |> Enum.into(%{
        name: "SOME NAME",
        workout_template_score: 0,
        is_finished: false
      })
      |> Fitness.WorkoutTemplates.create_workout_template()

    workout_template
  end
end
