defmodule FitnessWeb.Helpers do
  def relative_time(inserted_at) do
    {:ok, relative_str} =
      Timex.shift(inserted_at, minutes: -3) |> Timex.format("{relative}", :relative)

    relative_str
  end

  def present_date(date) do
    date
    |> Timex.format!("{D} {Mshort} {YYYY}")
  end
end
