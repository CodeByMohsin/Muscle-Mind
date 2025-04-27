defmodule Fitness.ExercisesTest do
  use Fitness.DataCase

  alias Fitness.Exercises

  describe "exercises" do
    alias Fitness.Exercises.Exercise

    import Fitness.ExercisesFixtures

    @invalid_attrs %{description: nil, gif_url: nil, level: nil, name: nil, type: nil}

    test "list_exercises/0 returns all exercises" do
      exercise = exercise_fixture()
      assert Exercises.list_exercises("some level") == [exercise]
    end

    test "get_exercise!/1 returns the exercise with given id" do
      exercise = exercise_fixture()
      assert Exercises.get_exercise!(exercise.id) == exercise
    end

    test "create_exercise/1 with valid data creates a exercise" do
      valid_attrs = %{
        description: "some description",
        gif_url: "some gif_url",
        level: "some level",
        name: "some name",
        type: "some type",
        equipment: "some equipment",
        body_part: "some body part"
      }

      assert {:ok, %Exercise{} = exercise} = Exercises.create_exercise(valid_attrs)
      assert exercise.description == "some description"
      assert exercise.gif_url == "some gif_url"
      assert exercise.level == "some level"
      assert exercise.name == "some name"
      assert exercise.type == "some type"
      assert exercise.body_part == "some body part"
      assert exercise.equipment == "some equipment"
    end

    test "create_exercise/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_exercise(@invalid_attrs)
    end

    test "update_exercise/2 with valid data updates the exercise" do
      exercise = exercise_fixture()

      update_attrs = %{
        description: "some updated description",
        gif_url: "some updated gif_url",
        level: "some updated level",
        name: "some updated name",
        type: "some updated type"
      }

      assert {:ok, %Exercise{} = exercise} = Exercises.update_exercise(exercise, update_attrs)
      assert exercise.description == "some updated description"
      assert exercise.gif_url == "some updated gif_url"
      assert exercise.level == "some updated level"
      assert exercise.name == "some updated name"
      assert exercise.type == "some updated type"
    end

    test "update_exercise/2 with invalid data returns error changeset" do
      exercise = exercise_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_exercise(exercise, @invalid_attrs)
      assert exercise == Exercises.get_exercise!(exercise.id)
    end

    test "delete_exercise/1 deletes the exercise" do
      exercise = exercise_fixture()
      assert {:ok, %Exercise{}} = Exercises.delete_exercise(exercise)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_exercise!(exercise.id) end
    end

    test "change_exercise/1 returns a exercise changeset" do
      exercise = exercise_fixture()
      assert %Ecto.Changeset{} = Exercises.change_exercise(exercise)
    end
  end
end
