defmodule FitnessWeb.ProfileLive.UpdateUserProfileForm do
  use FitnessWeb, :live_component

  alias Fitness.Accounts
  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> allow_upload(:user_image, accept: ~w(.jpg .png .jpeg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-8 bg-white rounded-lg">
      <h2 class="flex items-center justify-center pt-0 mb-4 text-3xl font-poppins">Edit Profile</h2>

         <.form
          :let={f}
          for={:profile}
          phx-target={@myself}
          id="update_profile"
          phx-change="update"
          phx-submit="update_new_changes">

          <%= for entry <- @uploads.user_image.entries do %>
          <div class="flex justify-center pt-6 mt-6">
          <.live_img_preview entry={entry} class="w-48 h-48 pb-4 rounded" />
          </div>
          <% end %>
          <div class="mb-4">
            <%= label f, :name, class: "block text-gray-700 font-bold mb-2" %>
            <%= text_input f, :name, class: "w-full font-poppins border rounded py-2 px-3 leading-tight focus:outline-none focus:shadow-outline", placeholder: "Edit name" %>
          </div>
          <div phx-drop-target={@uploads.user_image.ref} class="flex justify-center p-6 bg-gray-200 border-4 border-gray-600 border-dashed rounded-lg shadow">
          <label class="flex justify-center px-4 py-4 m-2 text-2xl cursor-pointer font-poppins">
                Click or drag and drop to upload image
                <.live_file_input upload={@upload.user_image} style="display: none;" />
          </label>
          </div>

          <div class="flex justify-between pt-4">
          <button class="button font-poppins" phx-click="remove" phx-target={@myself} >
            <svg class="svgIcon" viewBox="0 0 448 512"><path d="M135.2 17.7L128 32H32C14.3 32 0 46.3 0 64S14.3 96 32 96H416c17.7 0 32-14.3 32-32s-14.3-32-32-32H320l-7.2-14.3C307.4 6.8 296.3 0 284.2 0H163.8c-12.1 0-23.2 6.8-28.6 17.7zM416 128H32L53.2 467c1.6 25.3 22.6 45 47.9 45H346.9c25.3 0 46.3-19.7 47.9-45L416 128z"></path></svg>
          </button>

            <%= submit "Save", class: "bg-blue-500 hover:bg-blue-700 font-poppins text-white py-2 px-4 rounded focus:outline-none focus:shadow-outline", phx_disable_with: "Saving..." %>
           </div>
        </.form>
       </div>

    """
  end

  @impl true
  def handle_event("update", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("remove", _params, socket) do
    Accounts.update_user_image(socket.assigns.current_user, %{
      "image" => "/images/user-profile.svg"
    })

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_new_changes", %{"profile" => %{"name" => updated_name}}, socket) do
    uploaded_file =
      consume_uploaded_entries(socket, :user_image, fn %{path: path}, _entry ->
        file_name = Path.basename(path)
        File.cp!(path, "priv/static/images/#{file_name}")

        {:ok, Routes.static_path(socket, "/images/#{file_name}")}
      end)
      |> List.to_string()

    if uploaded_file != "" do
      Accounts.update_user_image(socket.assigns.current_user, %{"image" => uploaded_file})
    end

    Accounts.update_user_name(socket.assigns.current_user, %{"name" => updated_name})

    {:noreply,
     socket
     |> push_navigate(to: "/profile")}
  end
end
