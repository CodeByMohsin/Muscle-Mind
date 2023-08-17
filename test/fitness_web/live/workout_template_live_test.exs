defmodule FitnessWeb.WorkoutTemplateLiveTest do
  use FitnessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fitness.WorkoutTemplatesFixtures
  import Fitness.AccountsFixtures

  @create_attrs %{name: "SOME NAME"}
  @update_attrs %{name: "SOME UPDATED NAME"}
  @invalid_attrs %{name: nil}

  defp create_workout_template(_) do
    user = user_fixture()
    workout_template = workout_template_fixture(user_id: user.id)
    %{workout_template: workout_template, user: user}
  end

  describe "Index" do
    setup [:create_workout_template]

    test "lists all workout_templates", %{conn: conn, workout_template: workout_template, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, _index_live, html} = live(conn, Routes.workout_template_index_path(conn, :index))

      assert html =~ "Listing Workout templates"
      assert html =~ String.upcase(workout_template.name)
    end

    test "saves new workout_template", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, Routes.workout_template_index_path(conn, :index))

      assert index_live |> element("#new-workout", "NEW WORKOUT") |> render_click() =~
      "New Workout template"

      assert_patch(index_live, Routes.workout_template_index_path(conn, :new))

      assert index_live
      |> form("#workout_template-form", workout_template: @invalid_attrs)
      |> render_change() =~ "can&#39;t be blank"

      {:error, {:live_redirect, %{to: location}}} =
        index_live
        |> form("#workout_template-form", workout_template: @create_attrs)
        |> render_submit()

        {:ok, _, html} = live(conn, location)

      assert html =~ "SOME NAME"
    end

    test "updates workout_template in listing", %{conn: conn, workout_template: workout_template, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, Routes.workout_template_index_path(conn, :index))

      assert index_live |> element("#workout_template-#{workout_template.id} a", "Edit") |> render_click() =~
               "Edit Workout template"

      assert_patch(index_live, Routes.workout_template_index_path(conn, :edit, workout_template))

      assert index_live
             |> form("#workout_template-form", workout_template: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#workout_template-form", workout_template: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/workout_templates/#{workout_template.id}")

      assert html =~ "Workout template updated successfully"
      assert html =~ "SOME UPDATED NAME"
    end

    test "deletes workout_template in listing", %{conn: conn, workout_template: workout_template, user: user} do
      conn = conn |> log_in_user(user)

      {:ok, index_live, _html} = live(conn, Routes.workout_template_index_path(conn, :index))

      assert index_live |> element("#workout_template-#{workout_template.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#workout_template-#{workout_template.id}")
    end
  end

  describe "Show" do
    setup [:create_workout_template]

    test "displays workout_template", %{conn: conn, workout_template: workout_template, user: user} do
      conn = conn |> log_in_user(user)
      {:ok, _show_live, html} = live(conn, Routes.workout_template_show_path(conn, :show, workout_template))

      assert html =~ "Show Workout template"
      assert html =~ String.upcase(workout_template.name)
    end

    test "Add workout_items within modal", %{conn: conn, workout_template: workout_template, user: user} do
       conn = conn |> log_in_user(user)

       {:ok, show_live, _html} = live(conn, Routes.workout_template_show_path(conn, :show, workout_template))

       assert show_live |> element("a", "ADD EXERCISE") |> render_click() =~ "Add New Exercises"

       assert_patch(show_live, Routes.workout_template_show_path(conn, :edit, workout_template))

      #  assert show_live
      #         |> form("#workout_items_form", workout_items: @invalid_attrs_workout_items)
      #         |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   show_live
      #   |> form("#workout_template-form", workout_template: @update_attrs)
      #   |> render_submit()
      #   |> follow_redirect(conn, Routes.workout_template_show_path(conn, :show, workout_template))

      # assert html =~ "Workout template updated successfully"
      # assert html =~ "some updated name"
    end
  end
end
