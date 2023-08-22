defmodule FitnessWeb.LeadingPageLive.LeadingPage do
use FitnessWeb, :live_view

alias Fitness.Accounts

@impl true
def mount(_params, session, socket) do
current_user = Accounts.get_user_by_session_token(session["user_token"])

{:ok, assign(socket, :current_user, current_user)}
end

@impl true
def render(assigns) do
~H"""
<header>
  <nav id="nav" class="w-full z-10 fixed min-[700px]:min-w-[700px] h-[12rem] flex justify-around min-[750px]:justify-evenly items-center text-white">
    <div>
      <h1 class="text-xl font-[700] sm:text-2xl">Muscle Mind</h1>
      <h3
        class="relative text-[.625rem] sm:text-xs font-[600] mt-0 text-left text-transparent bg-clip-text bg-gradient-to-r from-orange-500 to-yellow-500">
        STRONGER EVERY DAY <svg class="absolute right-[-4px] top-[-2px]" xmlns="http://www.w3.org/2000/svg"
          height="1.5em"
          viewBox="0 0 640 512">
          <style>
            svg {
              fill: #dac22b
            }
          </style>
          <path
            d="M96 64c0-17.7 14.3-32 32-32h32c17.7 0 32 14.3 32 32V224v64V448c0 17.7-14.3 32-32 32H128c-17.7 0-32-14.3-32-32V384H64c-17.7 0-32-14.3-32-32V288c-17.7 0-32-14.3-32-32s14.3-32 32-32V160c0-17.7 14.3-32 32-32H96V64zm448 0v64h32c17.7 0 32 14.3 32 32v64c17.7 0 32 14.3 32 32s-14.3 32-32 32v64c0 17.7-14.3 32-32 32H544v64c0 17.7-14.3 32-32 32H480c-17.7 0-32-14.3-32-32V288 224 64c0-17.7 14.3-32 32-32h32c17.7 0 32 14.3 32 32zM416 224v64H224V224H416z" />
        </svg></h3>
    </div>

    <ul class="hidden  min-[750px]:flex justify-start items-baseline w-[40%] text-2xl font-[400]">
        <li>
         <a class="mr-24" href="#home">Home</a>
        </li>

        <li>
         <a class="mr-24" href="#">About</a>
        </li>

        <li>
         <a href="#features">Features</a>
        </li>
    </ul>

    <ul>
      <%= if @current_user do %>
        <li
          class="hidden w-[10rem] md:w-[12rem] h-[4rem] font-[700] text-2xl border-yellow-200 border-2 text-transparent bg-clip-text min-[750px]:flex justify-center items-center rounded-full bg-gradient-to-r from-yellow-500 to-orange-500 hover:text-white hover:bg-clip-content">
          <a href="#">Let Start</a>
        </li>
        <% else %>
          <li
            class="hidden w-[12rem] h-[4rem] font-[900] text-2xl border-white border-2 text-white min-[750px]:flex justify-center items-center rounded-full text-transparent bg-clip-text bg-gradient-to-r from-yellow-700 to-yellow-500 hover:text-white hover:bg-clip-content">
            <%= link "Register" , to: Routes.user_registration_path(@socket, :new) %>
          </li>
          <% end %>
    </ul>

    <div class="min-[750px]:hidden">
      <input id="phone-menu" type="checkbox" class="hidden">
      <label class="toggle toggle2 min-[750px]:hidden" for="phone-menu">
        <div id="bar4" class="bars"></div>
        <div id="bar5" class="bars"></div>
        <div id="bar6" class="bars"></div>
      </label>
    </div>
  </nav>
  <div id="cursor" class="hidden min-[850px]:block bg-gradient-to-r from-yellow-500 to-orange-500"></div>
  <div id="cursor-shadow" class="hidden min-[850px]:block  bg-gradient-to-r from-yellow-500 to-orange-500 opacity-[.3]"></div>
  <video autoplay loop muted src="/videos/lending_page_bg_video.mp4" class="w-full object-cover fixed top-0 z-[-1]" type='video/mp4'></video>
</header>

<main id="leading_page_main" class="overflow-hidden">
  <section id="home" class="w-screen h-screen flex justify-center items-center flex-col">
   <h1 class="text-7xl font-[800] text-white">Join a Community of Health Warriors</h1>
   <h3 class="text-4xl font-[600] text-white"> Muscle Mind Brings Fitness Enthusiasts Together. </h3>
  </section>
  <section id="features" class="w-screen h-screen">
   <h1>hello</h1>
   <h3>world</h3>
  </section>
</main>
"""
end
end
