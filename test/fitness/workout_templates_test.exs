defmodule Fitness.WorkoutTemplatesTest do
  use Fitness.DataCase

  alias Fitness.WorkoutTemplates

  describe "workout_templates" do
    alias Fitness.WorkoutTemplates.WorkoutTemplate

    import Fitness.WorkoutTemplatesFixtures

    @invalid_attrs %{name: nil}

    test "list_workout_templates/0 returns all workout_templates" do
      workout_template = workout_template_fixture()
      assert WorkoutTemplates.list_workout_templates() == [workout_template]
    end

    test "get_workout_template!/1 returns the workout_template with given id" do
      workout_template = workout_template_fixture() |> Repo.preload(:workout_items)
      assert WorkoutTemplates.get_workout_template!(workout_template.id) == workout_template
    end

    test "create_workout_template/1 with valid data creates a workout_template" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %WorkoutTemplate{} = workout_template} = WorkoutTemplates.create_workout_template(valid_attrs)
      assert workout_template.name == "some name"
    end

    test "create_workout_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkoutTemplates.create_workout_template(@invalid_attrs)
    end

    test "update_workout_template/2 with valid data updates the workout_template" do
      workout_template = workout_template_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %WorkoutTemplate{} = workout_template} = WorkoutTemplates.update_workout_template(workout_template, update_attrs)
      assert workout_template.name == "some updated name"
    end

    test "update_workout_template/2 with invalid data returns error changeset" do
      workout_template = workout_template_fixture() |> Repo.preload(:workout_items)
      assert {:error, %Ecto.Changeset{}} = WorkoutTemplates.update_workout_template(workout_template, @invalid_attrs)
      assert workout_template == WorkoutTemplates.get_workout_template!(workout_template.id)
    end

    test "delete_workout_template/1 deletes the workout_template" do
      workout_template = workout_template_fixture()
      assert {:ok, %WorkoutTemplate{}} = WorkoutTemplates.delete_workout_template(workout_template)
      assert_raise Ecto.NoResultsError, fn -> WorkoutTemplates.get_workout_template!(workout_template.id) end
    end

    test "change_workout_template/1 returns a workout_template changeset" do
      workout_template = workout_template_fixture()
      assert %Ecto.Changeset{} = WorkoutTemplates.change_workout_template(workout_template)
    end
  end
end
