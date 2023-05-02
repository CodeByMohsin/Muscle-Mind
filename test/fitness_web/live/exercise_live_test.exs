defmodule FitnessWeb.ExerciseLiveTest do
  use FitnessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fitness.ExercisesFixtures
  import Fitness.AccountsFixtures

  alias FitnessWeb.UserAuth
  alias Fitness.Accounts
  alias Fitness.Exercises

  @create_attrs %{
    description: "some description",
    gif_url: "some gif_url",
    level: "Others",
    name: "some name",
    type: "Others",
    equipment: "Others",
    body_part: "Others"
  }
  @update_attrs %{
    description: "some updated description",
    gif_url: "some updated gif_url",
    level: "Others",
    name: "some updated name",
    type: "Others",
    equipment: "Others",
    body_part: "Others"
  }
  @invalid_attrs %{description: nil, gif_url: nil, level: "Others", name: nil, type: "Others", equipment: "Others", body_part: "Others"}

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, FitnessWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    exercise = exercise_fixture()
    attrs = %{is_admin: true}
    user = user_fixture(attrs)

    %{conn: conn, user: user, exercise: exercise}
  end

  describe "Index" do
    test "lists all exercises", %{conn: conn, exercise: exercise} do
      {:ok, _index_live, html} = live(conn, Routes.exercise_index_path(conn, :index))
      assert html =~ "Search Exercises"
      assert html =~ exercise.name
    end

    test "list_exercise/1_ matching name, type, level" do
      exercise =
        exercise_fixture(name: "kDecline Crunch", level: "intermediate", type: "Strength")

      assert Exercises.list_exercises("kDecline intermediate Strength") == [exercise]
    end

    test "saves new exercise", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert index_live |> element("a", "New Exercise") |> render_click() =~
               "New Exercise"

      assert_patch(index_live, Routes.exercise_index_path(conn, :new))

      assert index_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#exercise-form", exercise: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_index_path(conn, :index))

      assert html =~ "Exercise created successfully"
      assert html =~ "some name"
    end

    test "updates exercise in listing", %{conn: conn, exercise: exercise, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))


      assert index_live |> element("#exercise-#{exercise.id} a", "Edit") |> render_click() =~
               "Edit Exercise"

      assert_patch(index_live, Routes.exercise_index_path(conn, :edit, exercise))

      assert index_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#exercise-form", exercise: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_index_path(conn, :index))

      assert html =~ "Exercise updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes exercise in listing", %{conn: conn, exercise: exercise, user: user} do

      conn = conn |> log_in_user(user)
      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert index_live |> element("#exercise-#{exercise.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#exercise-#{exercise.id}")
    end
  end

  describe "Show" do
    test "displays exercise", %{conn: conn, exercise: exercise, user: user} do
      conn = conn |> log_in_user(user)
      {:ok, _show_live, html} = live(conn, Routes.exercise_show_path(conn, :show, exercise))

      assert html =~ "Show Exercise"
      assert html =~ exercise.name
    end

    test "updates exercise within modal", %{conn: conn, exercise: exercise, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, show_live, _html} = live(conn, Routes.exercise_show_path(conn, :show, exercise))


      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Exercise"

      assert_patch(show_live, Routes.exercise_show_path(conn, :edit, exercise))

      assert show_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#exercise-form", exercise: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_show_path(conn, :show, exercise))

      assert html =~ "Exercise updated successfully"
      assert html =~ "some updated description"
    end
  end
end
