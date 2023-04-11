defmodule Fitness.ExercisesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fitness.Exercises` context.
  """

  @doc """
  Generate a exercise.
  """
  def exercise_fixture(attrs \\ %{}) do
    {:ok, exercise} =
      attrs
      |> Enum.into(%{
        description: "some description",
        body_part: "some body part",
        equipment: "some equipment",
        gif_url: "some gif_url",
        level: "some level",
        name: "some name",
        type: "some type"
      })
      |> Fitness.Exercises.create_exercise()

    exercise
  end
end
