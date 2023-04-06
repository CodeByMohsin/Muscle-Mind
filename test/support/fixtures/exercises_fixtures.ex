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
        gif_url: "some gif_url",
        level: "some level",
        name: "some name",
        type: "some type"
      })
      |> Fitness.Exercises.create_exercise()

    exercise
  end
end
