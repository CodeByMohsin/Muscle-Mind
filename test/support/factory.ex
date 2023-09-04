defmodule Fitness.Factory do
  alias Fitness.Repo
  alias Fitness.Chats.Schema.Message
  alias Fitness.Chats.Schema.Room

  def build(:message) do
    %Message{
      data: "sample message"
    }
  end

  def build(:room) do
    %Room{
      name: "general",
      visibility: :public,
      messages: []
    }
  end

  def build!(factory_name, attrs \\ []) do
    factory_name
    |> build()
    |> struct!(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    factory_name
    |> build!(attrs)
    |> Repo.insert!()
  end
end
