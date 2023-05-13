
## Muscle Mind Fitness Application

Muscle Mind is a fitness application built on Phoenix LiveView, designed to help you track your workouts, visualize your progress, access an exercise library, and compete on a real-time scoreboard. Additionally, the app provides a workout history page to keep track of your previous sessions.


## Lessons Learned

Throughout the development of Muscle Mind, several valuable lessons were learned. Here are some key takeaways from the project:

* **Don't shy away from seeking help** : It's important to recognize that asking for help and collaborating with others can greatly enhance the development process. Don't hesitate to reach out to the community or individuals with expertise in specific areas when facing challenges or seeking guidance.

* **Exploring Phoenix LiveView and Live Components** : Muscle Mind provided an opportunity to dive deep into Phoenix LiveView and Live Components. The project helped in gaining a better understanding of the real-time interactivity and powerful features offered by LiveView, enabling a more responsive and dynamic user experience.

* **Working with Ecto and the database** : Muscle Mind's integration with Ecto, the database wrapper for Elixir, allowed for seamless communication with the database. This experience provided insights into how to design and maintain a well-structured database schema, handle migrations, and efficiently query data for different application features.

* **Utilizing nested forms** : Implementing nested forms in Muscle Mind was a valuable learning experience. I discovered how to handle complex data structures and relationships, allowing users to log multiple exercises, sets, and reps within a single workout session. Nested forms provided a clean and intuitive user interface for data entry.

* **Leveraging code generation in Phoenix** : The Phoenix framework's code generation capabilities proved to be a valuable asset. Using Phoenix generators, I efficiently scaffolded initial code structures, including models, controllers, views, and templates. This allowed me to focus more on the specific application logic and functionality.

By embracing these lessons learned, I have strengthened my skills in web development using Elixir and Phoenix, and I look forward to applying these insights in future projects.

If you have any questions or need further assistance, please don't hesitate to reach out to me.
## Features

- `Workout Tracker` : Track your workouts with ease. Log details such as exercise, sets, reps, weights, and duration, allowing you to monitor your progress over time.
- `Progress Visualizations` : Visualize your progress through charts and graphs. Gain insights into your performance, set goals, and stay motivated throughout your fitness journey.
- `Exercise Library` : Access a comprehensive library of exercises. Explore various workouts, view detailed instructions, and learn proper form to maximize your results and minimize the risk of injury.
- `Scoreboard with PubSub` : Engage in friendly competition with other users on the real-time scoreboard. See who's on top and challenge yourself to climb the ranks.
- `Workout History` : Keep a record of your past workouts. Review previous sessions, analyze trends, and make informed decisions about your training program.


## Getting Started

To get started with Muscle Mind, follow these steps:

1. **Installation** : Clone the repository and navigate to the project directory.
```bash
git clone https://github.com/0xmohsinpathan/muscle-mind.git
cd muscle-mind 
```
2. **Environment Setup** : Ensure that you have Elixir and Phoenix installed on your system.
3. **Database Setup** : Create a new PostgreSQL database for Muscle Mind and update the database configuration in config/dev.exs.
4. **Dependency Installation** : Install the project dependencies.
```bash
mix deps.get 
```
5. **Database Migration** : Run the database migration to set up the required tables.
```bash
mix ecto.migrate
```
6. **Starting the Application** : Start the Phoenix server.
```bash
mix phx.server
```
7. **Accessing the Application** : Open your web browser and visit http://localhost:4000 to access the Muscle Mind application.
    
## Credits

Credit is due to the website [uiverse.io](https://uiverse.io/) for providing us with their amazing UI elements, which we are free to use in our application.

*Their CSS button styles have greatly improved the visual appeal of our project, and I am thankful for their talent and generosity in sharing them.*

To create an exercise library using CSV file, I utilized two CSV files: the [Gym Exercise Dataset](https://www.kaggle.com/datasets/niharika41298/gym-exercise-data) and [Fitness Exercises](https://www.kaggle.com/datasets/edoardoba/fitness-exercises-with-animations). By extracting the necessary information from both files, I was able to convert the data into Elixir code. An example of this process can be found on my GitHub repository titled [CSV_file_convert_to_Elixir_code](https://github.com/0xmohsinpathan/CSV_file_convert_to_Elixir_code).
## Acknowledgements

*Muscle Mind is built using the Phoenix LiveView framework, which provides real-time interactivity and seamless user experiences. We would like to thank the Phoenix community for their continuous support and contributions.*
## Contributing

*Contributions to Muscle Mind are welcome! If you encounter any bugs or have suggestions for new features, please open an issue in the GitHub repository. If you would like to contribute code, submit a pull request with your proposed changes.*


## License


Muscle Mind is released under the [MIT License](https://choosealicense.com/licenses/mit/) . Feel free to modify and use the codebase according to your needs.
## Support

If you have any questions or need further assistance, please email me 0xmohsinpathan@gmail.com or DM me on Twitter.


## 🔗 Links

[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/0xMohsin)



## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
