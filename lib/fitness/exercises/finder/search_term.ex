defmodule Fitness.Exercises.Finder.SearchTerm do

  def filter_by_search_term(exercises, search_query) do


    found_search_query =
      case search_query do
        "" ->
          exercises

        search_query ->
          words = search_query |> String.downcase() |> String.split()

          exercises
          |> Enum.filter(fn exercise ->
            texts =
              [
                exercise.name |> String.downcase(),
                exercise.level |> String.downcase(),
                exercise.type |> String.downcase(),
                exercise.body_part |> String.downcase(),
                exercise.equipment |> String.downcase()
              ]
              |> Enum.join()

            Enum.all?(words, fn word ->
              String.contains?(texts, word)
            end)
          end)
      end

    found_search_query
  end

end
