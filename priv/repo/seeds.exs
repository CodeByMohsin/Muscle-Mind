# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fitness.Repo.insert!(%Fitness.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Fitness.Exercises
alias Fitness.Accounts


File.read!("priv/repo/list_of_exercises.txt")
|> :erlang.binary_to_term()
|> Enum.uniq()
|> Enum.each(fn workout -> Exercises.create_exercise(workout) end)


Accounts.register_user(%{email: "test@test.com", password: "test@test.com", is_admin: true })
