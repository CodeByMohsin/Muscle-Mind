# Script to generate workout templates from JSON exercise data
# Run with: mix run priv/repo/workout_templates_generator.exs
defmodule Fitness.Data.Setup do
  alias Fitness.Repo
  alias Fitness.Accounts
  alias Fitness.Exercises.Exercise
  alias Fitness.WorkoutTemplates.WorkoutTemplate
  alias Fitness.WorkoutTemplates.WorkoutItem

  def run do
    # Create users or get existing ones
    {:ok, user1} =
      Accounts.register_user(%{
        email: "test@test9.com",
        password: "mak12345",
        is_admin: false,
        username: "The-Bird-Man",
        name: "marko",
        player_score: "500"
      })

    {:ok, user2} =
      Accounts.register_user(%{
        email: "test@test10.com",
        password: "mak12345",
        is_admin: false,
        username: "Elixir-Newbie",
        name: "mohsin",
        player_score: "2000"
      })

    # Parse the JSON exercise data
    exercise_data =
      [
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The single-kettlebell windmill is a dynamic kettlebell exercise emphasizing core strength and shoulder and hip mobility and stability. It is often used as a functional warm-up or for multi-directional strength work. It doesn't work as well in a metcon or conditioning setting, and shouldn't be performed under intense fatigue.",
          "equipment" => "Kettlebells",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0554.gif",
          "level" => "Intermediate",
          "name" => "Kettlebell Windmill",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The kettlebell swing is a popular lower-body exercise emphasizing the hamstrings, glutes, and back muscles. It is often used to train explosive power, for aerobic or cardiovascular conditioning, in circuit training, or as an accessory movement for the deadlift.",
          "equipment" => "Kettlebells",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0549.gif",
          "level" => "Intermediate",
          "name" => "Kettlebell swing",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The dumbbell side bend is a popular exercise for targeting the oblique muscles of the abdomen. It is usually performed for relatively high reps, at least 8-12 reps per set or more. It can be performed one side at a time or alternating sides.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0407.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell side bend",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The barbell press sit-up is a weighted exercise focusing on the abdominal muscles, as well as the shoulders to a lesser degree. It primarily targets the rectus abdominis or \"six-pack\" muscles, but also involves the obliques and deep core muscles. It can be performed on the floor with the feet anchored or unanchored, or on a decline or other bench. It is similar to the Otis-up, which is performed with a weight plate.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0071.gif",
          "level" => "Intermediate",
          "name" => "Barbell press sit-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The cable reverse crunch is performed on the ground facing away from a high pulley, which helps target the lower abdominals specifically.",
          "equipment" => "Cable",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0873.gif",
          "level" => "Beginner",
          "name" => "Cable reverse crunch",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The cocoon crunch is a bodyweight exercise targeting the ab muscles, the rectus abdominis or \"six-pack\" muscles in particular. It involves bringing your knees to your chest and your arms from overhead to center. It can be performed for time or reps as part of the ab-focused portion of any workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0260.gif",
          "level" => "Intermediate",
          "name" => "Cocoons",
          "type" => "Strength"
        },
        %{
          "body_part" => "shoulders",
          "description" =>
            "A compound exercise for the shoulders and triceps. Standing with a barbell at shoulder height, press the weight overhead until your arms are fully extended.",
          "equipment" => "barbell",
          "gif_url" => "https://example.com/overhead-press.gif",
          "level" => "intermediate",
          "name" => "Overhead Press",
          "type" => "strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The decline crunch is an effective core exercise targeting the rectus abdominis.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0277.gif",
          "level" => "Intermediate",
          "name" => "Decline Crunch",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The hanging oblique crunch an abdominal exercise that targets both the rectus abdominus or “six-pack” muscles, and the oblique muscles. It can be performed hanging from a bar, or if grip strength is a limitation, by placing the elbows in ab straps. If hanging from a straight bar is uncomfortable to the wrists or shoulder, you can also perform them hanging with a neutral grip (palms facing one another)",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1761.gif",
          "level" => "Intermediate",
          "name" => "Hanging Oblique Knee Raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The hanging leg raise is an exercise targeting the abs, but which also works the lats and hip flexors. Instead of resting your forearms on the pads of a captain's chair, you perform these hanging from a bar. Experienced lifters make these look easy, but beginners may need time to build up to sets of 8-12 reps.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0472.gif",
          "level" => "Intermediate",
          "name" => "Hanging leg raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The mountain climber is a popular bodyweight exercise targeting the muscles of the core, as well as the shoulders, hips, and cardiovascular system. It involves lifting one knee to the chest at a time from a straight-arm plank position. It can be performed for time or reps as part of a dynamic warm-up, for bodyweight cardio or conditioning, or as no-equipment dynamic core training.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0630.gif",
          "level" => "Intermediate",
          "name" => "Mountain climber",
          "type" => "Plyometrics"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The 3/4 sit-up is a bodyweight exercise focused on the muscles of the core. It is similar to a sit-up, but stops short of the top position. This keeps constant tension on the abs, making it more difficult than traditional sit-ups. It can be performed for time or for reps, with the feet anchored or free, as part of the ab-focused portion of any workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0001.gif",
          "level" => "Intermediate",
          "name" => "3/4 sit-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The reverse crunch is a popular exercise targeting the abdominals, particularly the lower half. It’s easy to perform on either the floor or a flat bench. Many lifters think of this as a companion to the crunch, which targets the upper abdominals more than the lower.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0872.gif",
          "level" => "Intermediate",
          "name" => "Reverse crunch",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The Russian twist is an exercise targeting the abdominals and the obliques. Beginning from a position that resembles stopping midway through a sit-up, it involves twisting side to side. It can be performed with body weight alone or while holding a weight plate or other object. It is performed by alternating sides with each rep and can be done for time or for a specific number of reps as part of the ab-focused portion of any workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0687.gif",
          "level" => "Intermediate",
          "name" => "Russian twist",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The bear crawl is a popular bodyweight crawling exercise. While it looks simple, the bear crawl is an intense full-body movement that targets the cardiovascular system as well as a wide range of muscle groups, the shoulders, core, and legs in particular. It can be done as a full-body warm-up, in short bursts for power or circuit training, or for longer durations as cardiovascular conditioning.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/3360.gif",
          "level" => "Intermediate",
          "name" => "Bear crawl",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The shoulder tap is an exercise targeting the abdominals and core. The basic stance matches the top of a push-up position. From there, one hand is raised to tap its opposing shoulder. A tap with each hand to each opposing shoulder equals one rep.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/3699.gif",
          "level" => "Intermediate",
          "name" => "Shoulder tap",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The push-up to side plank is an upper-body and core-focused exercise combining two popular bodyweight movements. It targets the chest, triceps, and shoulders with the push-up, and the obliques and hip external rotator muscles with the side plank. It can be performed as part of a dynamic warm-up or any bodyweight strength-training workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0664.gif",
          "level" => "Intermediate",
          "name" => "Push-up to side plank",
          "type" => "Strength"
        },
        %{
          "body_part" => "Abdominals",
          "description" =>
            "The decline sit-up is a bodyweight core exercise that works the rectus abdominis or \"six pack\" muscles. Sit-up variations are usually performed for moderate to high reps, such as 10-15 reps per set or more, as part of the core-focused portion of a workout.",
          "equipment" => "None",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0282.gif",
          "level" => "Intermediate",
          "name" => "Decline sit-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Biceps",
          "description" =>
            "The barbell curl is an arm exercise that is also one of the most recognizable movements in all of bodybuilding and fitness. It helps build sleeve-popping biceps and allows heavier loading than many other curl variations. It is usually performed in moderate to high reps, such as 8-12 reps per set, as part of the arm-focused portion of any workout.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0031.gif",
          "level" => "Intermediate",
          "name" => "Barbell Curl",
          "type" => "Strength"
        },
        %{
          "body_part" => "Biceps",
          "description" =>
            "The dumbbell preacher curl is an exercise that focuses on building the biceps, particularly the biceps peak. All you need is a pair of dumbbells and a preacher bench. It's usually performed for moderate to high reps as part of an upper-body or arms-focused workout.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0372.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell preacher curl",
          "type" => "Strength"
        },
        %{
          "body_part" => "Biceps",
          "description" =>
            "The dumbbell biceps curl is a single-joint exercise for building bigger and stronger biceps. Popular among gym goers of all experience levels, this move can be done seated or standing. It is generally performed for moderate to high reps, such as 8-12 reps or higher, as part of the arm-focused portion of a workout.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0294.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell biceps curl",
          "type" => "Strength"
        },
        %{
          "body_part" => "Calves",
          "description" =>
            "The weighted donkey calk raise is a strength and muscle-building exercise focused on the muscles of the lower leg, most prominently the gastrocnemius muscle. While traditional donkey calf raises involved either a specific machine or carrying another person on one's back, this method uses a weight belt. It can be done in traditional muscle-building rep ranges, or for higher reps as part of lower-body training.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0833.gif",
          "level" => "Intermediate",
          "name" => "Weighted donkey calf raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The kettlebell plyo push-up is an explosive upper-body movement that uses a kettlebell primarily as a platform for the hands. A short step, dumbbell, or other stationary object could also be used in place of the kettlebell. It can be performed for reps or time, either for low reps to build explosive power or for higher reps for conditioning.",
          "equipment" => "Kettlebells",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0545.gif",
          "level" => "Intermediate",
          "name" => "Kettlebell plyo push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The hands-elevated push-up is a variation on the push-up, a body-weight standard. The hands are elevated, so that your body is aligned at an angle to the floor rather than parallel.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0493.gif",
          "level" => "Intermediate",
          "name" => "Incline Push-Up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The feet-elevated push-up is a variation on the push-up, a body-weight standard. The feet are elevated, so that your body is aligned at an angle to the floor rather than parallel.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0279.gif",
          "level" => "Intermediate",
          "name" => "Decline Push-Up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The typewriter push-up is an advanced push-up variation where the hands are extra wide and you lower toward each hand in alternating reps. It is more challenging to each working arm than traditional push-ups and also stretches and challenges the chest.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0500.gif",
          "level" => "Beginner",
          "name" => "Isometric Wipers",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The clock push-up is a series of regular push-ups performed one at a time, moving your hands one step to the side between each one until you've completed a full circle. It targets the same muscles as traditional push-ups, such as the chest, triceps, and shoulders, but adds an endurance and core challenge to traditional push-ups.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0258.gif",
          "level" => "Beginner",
          "name" => "Clock push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The suspended push-up is a bodyweight pushing exercise performed on a suspension strap system or gymnastic rings. It targets the chest, shoulders, and triceps, but is also challenging to the core and upper back. It can work in traditional strength and muscle-building rep ranges or for higher reps.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0806.gif",
          "level" => "Intermediate",
          "name" => "Suspended push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The diamond push-up is an advanced variation of the push-up exercise performed with the hands in a diamond shape. It increases the challenge to the triceps, but also targets the chest and shoulders.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0283.gif",
          "level" => "Intermediate",
          "name" => "Diamond push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The push-up is a popular bodyweight exercise that is commonly used in military and tactical physical fitness tests. It’s a classic movement to build upper-body muscle and strength, emphasizing the chest, triceps, and shoulders, but also working the upper back and core.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0662.gif",
          "level" => "Intermediate",
          "name" => "Push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The medicine ball pass is a simple partner-based exercise that involves throwing a weighted ball back-and-forth. It can be part of a dynamic warm-up for lifting or athletics, but can also work as active rest or as a component of circuit training.",
          "equipment" => "Medicine Ball",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1302.gif",
          "level" => "Intermediate",
          "name" => "Medicine Ball Chest Pass",
          "type" => "Plyometrics"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The dumbbell bench press is a mainstay of workout enthusiasts worldwide. It’s a classic move for building a bigger, stronger chest. As such, it’s often placed first in mass-building chest workouts.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0289.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell Bench Press",
          "type" => "Strength"
        },
        %{
          "body_part" => "Chest",
          "description" =>
            "The chest dip is a bodyweight exercise performed on parallel bars or on a pull-up and dip station. It targets the chest, triceps, and shoulders. Dips with a chest focus are usually performed with the torso leaning forward and the elbows angled out from the torso. Dips can be performed for low reps for strength or higher reps for muscle growth.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0251.gif",
          "level" => "Intermediate",
          "name" => "Chest dip",
          "type" => "Strength"
        },
        %{
          "body_part" => "Glutes",
          "description" =>
            "The barbell glute bridge is a popular exercise targeting the muscles of the glutes and hamstrings. It can be done as a strength movement on its own, as an activation drill or warm-up for lower-body training, or as a burnout at the end of a lower-body workout.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1409.gif",
          "level" => "Intermediate",
          "name" => "Barbell glute bridge",
          "type" => "Powerlifting"
        },
        %{
          "body_part" => "Glutes",
          "description" =>
            "The kettlebell thruster is a popular kettlebell movement that combines a kettlebell front squat with a kettlebell press, while holding the bell in a goblet or bottoms-up grip. It is preceded by a clean at the start of each set, and you can perform a clean between each rep if you choose. It can be trained in traditional strength or muscle-building rep ranges, in circuit or fat-loss training, or as part of a larger kettlebell combination or complex.",
          "equipment" => "Kettlebells",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0550.gif",
          "level" => "Intermediate",
          "name" => "Kettlebell thruster",
          "type" => "Strength"
        },
        %{
          "body_part" => "Glutes",
          "description" =>
            "The walking lunge is a lower-body exercise that targets the glutes, quads, and hamstrings while challenging stability and balance. It can be performed for reps, time, or distance in the lower-body portion of any workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1460.gif",
          "level" => "Intermediate",
          "name" => "Walking lunge",
          "type" => "Strength"
        },
        %{
          "body_part" => "Hamstrings",
          "description" =>
            "The barbell deadlift is a compound exercise used to develop overall strength and size in the posterior chain. It is a competition lift in the sport of powerlifting, but is also considered a classic benchmark of overall strength. When performed with the hands outside the knees, it is often called a \"conventional\" deadlift. When the feet are wide and the hands are inside the knees, it is a sumo deadlift.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0032.gif",
          "level" => "Intermediate",
          "name" => "Barbell Deadlift",
          "type" => "Strength"
        },
        %{
          "body_part" => "Hamstrings",
          "description" =>
            "The power clean is a full-body movement in which the bar is pulled from the floor and caught in the front rack position in three pulls or phases. The bar is received in the \"power\" position, with the hips higher than a full-depth squat position. The power clean can be used as a component of the clean and press or clean and jerk, but is also a valuable lift to build explosive power and strength.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0648.gif",
          "level" => "Intermediate",
          "name" => "Power clean",
          "type" => "Strength"
        },
        %{
          "body_part" => "Hamstrings",
          "description" =>
            "The inchworm is a popular bodyweight exercise that involves “walking” the hands on the floor from a bent-over toe-touch position into a straight-arm plank. It is usually performed as part of a dynamic warm-up to help raise core body temperature and “limber up” the body from head to toe.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1471.gif",
          "level" => "Beginner",
          "name" => "Inchworm",
          "type" => "Stretching"
        },
        %{
          "body_part" => "Lats",
          "description" =>
            "The weighted pull-up is a more advanced variation of the pull-up exercise in which the lifter adds extra weight to their body. Options for adding weight include a dip belt, weighted vest, chains, a dumbbell placed between the feet or legs, or looping a kettlebell over the foot. Like other pull-up variations, the weighted pull-up builds strength and muscle in the upper back, biceps, and core.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0841.gif",
          "level" => "Intermediate",
          "name" => "Weighted pull-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Lats",
          "description" =>
            "The pull-up is a multijoint bodyweight exercise that builds strength and muscle in the upper back, biceps, and core. It is often used as a measurement tool in military or tactical fitness tests, and is an excellent gauge of \"relative strength\" which is strength in relation to body weight.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0652.gif",
          "level" => "Beginner",
          "name" => "Pull-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Lats",
          "description" =>
            "The rope climb is an exercise that is used commonly in CrossFit workouts and as a test of upper-body strength. It was even contested at the Olympics in the early 20th century. It targets a wide range of upper-body musculature, including the hands and forearms, shoulders, biceps, lats (latissimus dorsi), and core.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0680.gif",
          "level" => "Intermediate",
          "name" => "Rope climb",
          "type" => "Strength"
        },
        %{
          "body_part" => "Lats",
          "description" =>
            "The a chin-up is a variation of the pull-up exercise in which the reps are performed with the palms facing toward the body, in an underhand position, with a grip that is narrower than shoulder-width. Like other pull-up variations, it builds strength and muscle in the upper back, biceps, and core, but it utilizes the biceps slightly more than overhand pull-ups. It can be used as a more shoulder-friendly alternative to straight-bar pull-ups, or to help perform more reps than you can perform overhand.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1326.gif",
          "level" => "Intermediate",
          "name" => "Chin-Up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Lats",
          "description" =>
            "The iron cross stretch is a bodyweight stretch that focuses on hip and thoracic spine mobility.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1419.gif",
          "level" => "Intermediate",
          "name" => "Iron cross stretch",
          "type" => "Strength"
        },
        %{
          "body_part" => "Lower Back",
          "description" =>
            "The barbell good morning is an exercise that targets glute, hamstring, and lower back development. It is often trained as an accessory movement to the deadlift, but also has value on its own. It is sometimes performed for reps in traditional strength-focused rep ranges such as 5-8 reps per set, but due to the risk posed to the lower back, is rarely treated as a max-effort single-rep lift.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0044.gif",
          "level" => "Intermediate",
          "name" => "Barbell good morning",
          "type" => "Strength"
        },
        %{
          "body_part" => "Middle Back",
          "description" =>
            "The kettlebell alternating renegade row combines rowing and core training into a single difficult movement. It's popular in time-efficient strength and muscle-building workouts, as well as in circuit-style training.",
          "equipment" => "Kettlebells",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0521.gif",
          "level" => "Intermediate",
          "name" => "Kettlebell alternating renegade row",
          "type" => "Strength"
        },
        %{
          "body_part" => "Middle Back",
          "description" =>
            "The suspended row is a bodyweight pulling exercise that focuses on the muscles of the middle and upper back, as well as the biceps. It can be trained in traditional muscle-building rep ranges or for higher reps. It can also work as part of a dynamic warm-up for a pressing or pulling-focused workout.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0808.gif",
          "level" => "Intermediate",
          "name" => "Suspended row",
          "type" => "Strength"
        },
        %{
          "body_part" => "Traps",
          "description" =>
            "The barbell shrug is an exercise targeting the traps (trapezius muscles). It is popular in strength and muscle-focused upper-body training, and is often trained on a shoulder day. With the assistance of straps, it can be loaded heavily, but it is still usually performed for moderate to high reps, such as 8-10 reps per set.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0095.gif",
          "level" => "Intermediate",
          "name" => "Barbell shrug",
          "type" => "Strength"
        },
        %{
          "body_part" => "Traps",
          "description" =>
            "The cable shrug is an exercise targeting the traps, as well as hitting the shoulders and upper back. Cables allow for lighter loading which is beneficial for higher-rep sets.",
          "equipment" => "Cable",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0220.gif",
          "level" => "Intermediate",
          "name" => "Cable shrug",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell back squat is a popular compound movement that emphasizes building the lower-body muscle groups and overall strength. It's the classic way to start a leg day, and is a worthy centerpiece to a lower-body training program. The squat is a competitive lift in the sport of powerlifting, but is also a classic measurement of lower-body strength. With the barbell racked on the traps or upper back, the emphasis is placed on the posterior chain but the entire body gets worked. The back squat can be trained in everything from heavy singles to sets of 20 reps or higher.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0043.gif",
          "level" => "Intermediate",
          "name" => "Barbell Full Squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell front squat is a compound movement that emphasizes building the lower-body muscle groups. With the barbell racked in front of the body on the anterior delts, the front squat emphasizes the quads and glutes, but also upper back and core strength to remain upright. Front squats can be trained as an alternative to back squats, as an accessory movement for either squats or deadlifts, or for strength and muscle on their own. Many lifters and athletes prefer them to back squats, although they can be uncomfortable and difficult to learn at first.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0042.gif",
          "level" => "Intermediate",
          "name" => "Barbell front squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell step-up is a great exercise for building lower-body strength and power. It targets all the same muscles as bodyweight step-ups, such as the quads, glutes, and hamstrings, but allows for greater muscular overload.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0114.gif",
          "level" => "Intermediate",
          "name" => "Barbell step-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell hack squat is a variety of deadlift performed with the barbell behind the legs. This forces the lifter into a body position similar to a squat and targets the quads and glutes. It is named after famed strongman George Hackenschmidt, who performed it as an overall leg-building exercise. The barbell hack squat can be used as a substitute for the machine hack squat, or as a lower-body strength and size movement on its own.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0046.gif",
          "level" => "Expert",
          "name" => "Barbell hack squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell thruster is a full-body exercise that incorporates both squatting and pressing in one functional movement. It's especially common in contemporary CrossFit workouts, but also in general strength training. The barbell is usually cleaned into place first, but it could be performed taken from a squat rack in a front-rack position. The thruster can be performed in traditional strength-focused rep ranges to build strength in the press, or in higher reps for full-body conditioning.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/3305.gif",
          "level" => "Intermediate",
          "name" => "Barbell thruster",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell side split squat is a variation of the split squat that targets the lower body, specifically the quads, and requires good hip mobility.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0098.gif",
          "level" => "Intermediate",
          "name" => "Barbell side split squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The barbell speed squat targets the lower-body muscle groups using lighter weights to perform fast-paced back squats. Speed squats are popular in certain powerlifting training methodologies as a way to engrain form and lifting speed that can carry over to max-effort lifts. In this approach, they are usually performed in numerous sets of 3-5 reps with adequate rest in between. Speed squats are also sometimes performed with bands or chains adding extra resistance to the top half of the lift.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0101.gif",
          "level" => "Intermediate",
          "name" => "Barbell speed squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The goblet squat is a common exercise used in the early stages of learning to squat, or as a movement in general training programs for building size to the quads, glutes, and hamstrings.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1760.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell Goblet Squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The dumbbell squat is a classic lower-body exercise that targets the quadriceps, hamstrings, and glutes. While this variation is usually performed with relatively light weights for high reps, it can also be used as a substitute for squats or the trap-bar deadlift in any workout.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0413.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The dumbbell step-up is a great exercise for building lower-body strength and power. It targets all the same muscles as bodyweight step-ups, such as the quads, glutes, and hamstrings, but allows for greater muscular overload.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0431.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell step-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The dumbbell deadlift is a movement that targets the hamstrings, glutes, and back muscles. While it can be performed all the way from the ground, in the style of a barbell deadlift, it is more often performed from the top down as a Romanian deadlift. The dumbbell deadlift can be performed in low rep ranges to build posterior strength, or for moderate to high reps to build muscle and endurance.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0300.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell deadlift",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The tire flip is an exercise that works the entire body, starting from a deadlift position and ending with a giant tire being flipped over. Each flip moves the tire farther in one direction until a set has been completed. It can be performed for time or reps as part of a functional fitness or athleticism-focused workout.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/2459.gif",
          "level" => "Intermediate",
          "name" => "Tire flip",
          "type" => "Strongman"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The weighted sissy squat is an exercise primarily targeting the quadriceps. In sissy squats, the knees travel over the toes, placing the quads under a fairly extreme stretch. They are usually performed for moderate to high reps as part of a lower-body training session.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0851.gif",
          "level" => "Intermediate",
          "name" => "Weighted sissy squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The dumbbell step-up is a great exercise for building lower-body strength and power. It targets all the same muscles as bodyweight step-ups, such as the quads, glutes, and hamstrings, but allows for greater muscular overload.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0431.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell step-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The suspended split squat is a single-leg squat variation performed with the rear leg in a suspension strap system. This allows the rear leg to move slightly more naturally than it would be able to on a bench. The exercise targets the quads, hamstring, and glute muscles on the front leg, but also taxes and stretches the quads on the rear leg.",
          "equipment" => "Other",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0809.gif",
          "level" => "Intermediate",
          "name" => "Suspended split squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The burpee is a high-intensity exercise that recruits the entire body to build strength and aerobic capacity. It is common in CrossFit workouts and group fitness classes, but can also be performed for time or reps in any fat-loss or athleticism-focused circuit or workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1160.gif",
          "level" => "Intermediate",
          "name" => "Burpee",
          "type" => "Cardio"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The jump squat is an explosive bodyweight exercise targeting the quads, hamstrings, and glutes. It is also a serious cardiovascular challenge when done for reps. It can be performed as a power exercise to build jumping power, or in any fat-loss or athleticism-focused workout.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0514.gif",
          "level" => "Intermediate",
          "name" => "Jump Squat",
          "type" => "Plyometrics"
        },
        %{
          "body_part" => "Quadriceps",
          "description" =>
            "The sissy squat is a bodyweight squat variation that involves letting the knees travel far over the toes, placing an extreme stretch on the quads. This movement targets the quad muscles directly and can be performed in partial or full ranges of motion based on knee health and pain.",
          "equipment" => "None",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/1489.gif",
          "level" => "Intermediate",
          "name" => "Sissy squat",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The band shoulder press is a deltoid exercise and an alternative to the classic dumbbell shoulder press. The dynamic tension of the band forces the core to stabilize the body and more closely matches the strength curve of the shoulder press. It can be performed in low reps, such as 5-8 reps per set, to build shoulder strength, or for higher reps to build muscle and for conditioning. It can work as the main focus of a shoulder day but is also popular as an accessory movement to the bench press or barbell military press.",
          "equipment" => "Bands",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0997.gif",
          "level" => "Intermediate",
          "name" => "Band shoulder press",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The barbell upright row is a barbell exercise that builds stronger and bigger traps. Many lifters combine this move with either their back or shoulder workout since it involves both body parts.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0120.gif",
          "level" => "Intermediate",
          "name" => "Barbell upright row",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The barbell front raise is an upper-body isolation exercise that targets the shoulders. It is usually performed for moderate to high reps, such as 8-12 reps or higher, as part of the shoulder-focused part of any workout.",
          "equipment" => "Barbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0041.gif",
          "level" => "Intermediate",
          "name" => "Barbell front raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The dumbbell front raise is a single-joint exercise targeting the shoulder muscles, particularly the front or anterior deltoids. It is usually performed for moderate to high reps, at least 8-12 reps per set, as part of an upper-body or shoulder-focused workout.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0310.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell front raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The incline dumbbell reverse fly is an upper-body exercise targeting the posterior or rear deltoids, as well as the postural muscles of the upper back. Because it targets such small muscles, this exercise is usually performed with light weight for high reps, such as 10-15 reps per set or more.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0348.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell Lying Rear Lateral Raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The dumbbell lateral raise is a shoulder exercise that targets the medial or middle head of the deltoid muscle. It's a staple strength-training move and is a great option for accessory work on upper-body training days. It is usually performed for moderate to high reps, at least 8-12 reps, as part of the upper-body or shoulder-focused portion of a workout.",
          "equipment" => "Dumbbell",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0334.gif",
          "level" => "Intermediate",
          "name" => "Dumbbell lateral raise",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The cable seated row is a popular exercise to train the muscles of the upper back, including the lats (latissimus dorsi), traps, rhomboids, and rear deltoids, using a cable stack. It also targets the biceps to a lesser degree. The cable row can work well in a variety of rep ranges but is most popular in muscle-building workouts or as an accessory movement for strength workouts.",
          "equipment" => "Cable",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0861.gif",
          "level" => "Intermediate",
          "name" => "Cable seated row",
          "type" => "Strength"
        },
        %{
          "body_part" => "Shoulders",
          "description" =>
            "The handstand push-up is an exercise targeting the shoulders, although other muscles assist in the completion of the reps. It is common in both CrossFit workouts and advanced bodyweight or calisthenics training. Given the degree of difficulty, beginners will need to progress to this move.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0471.gif",
          "level" => "Intermediate",
          "name" => "Handstand push-up",
          "type" => "Strength"
        },
        %{
          "body_part" => "Triceps",
          "description" =>
            "The triceps dip is a bodyweight exercise performed on parallel bars or on a pull-up and dip station. It targets the triceps first, but also stretches and strengthens the chest and shoulders. Dips with a triceps focus are usually performed with an upright torso, the knees bent and crossed, and the arms close to the body. Dips can be performed for low reps for strength or higher reps for muscle growth.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0814.gif",
          "level" => "Intermediate",
          "name" => "Triceps dip",
          "type" => "Strength"
        },
        %{
          "body_part" => "Triceps",
          "description" =>
            "The weighted bench dip is a highly effective exercise for building the triceps. The resistance comes from a combination of body weight and added weight—usually a weight plate.",
          "equipment" => "Body Only",
          "gif_url" => "http://d205bpvrqc9yn1.cloudfront.net/0830.gif",
          "level" => "Intermediate",
          "name" => "Weighted bench dip",
          "type" => "Strength"
        }
      ]

    # Create all exercises from the JSON data and build a map for easy lookup
    exercises_map = %{}

    exercises_map =
      Enum.reduce(exercise_data, exercises_map, fn exercise_json, acc ->
        # Create a unique key for each exercise
        key =
          exercise_json["name"]
          |> String.downcase()
          |> String.replace(~r/[^a-z0-9]+/, "_")
          |> String.trim("_")

        # Create the exercise in the database
        exercise =
          Repo.insert!(%Exercise{
            name: exercise_json["name"],
            description: exercise_json["description"],
            gif_url: exercise_json["gif_url"],
            level: String.downcase(exercise_json["level"]),
            type: String.downcase(exercise_json["type"]),
            equipment: String.downcase(exercise_json["equipment"]),
            body_part: String.downcase(exercise_json["body_part"])
          })

        # Add the exercise to our map
        Map.put(acc, key, exercise)
      end)

    # Helper function to get exercise by name
    get_exercise = fn name ->
      key =
        name
        |> String.downcase()
        |> String.replace(~r/[^a-z0-9]+/, "_")
        |> String.trim("_")

      Map.get(exercises_map, key)
    end

    # ==================== 1. PUSH/PULL/LEGS SPLIT ====================

    # Push Day (Chest, Shoulders, Triceps)
    push_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Push Day (Chest, Shoulders, Triceps)",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of bench press with pyramid weights
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 30.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: push_template.id
    })

    # Multiple sets of push-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: push_template.id
    })

    # Multiple sets of overhead press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 15.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: push_template.id
    })

    # Multiple sets of lateral raises
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 8.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell lateral raise").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 6.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("dumbbell lateral raise").id,
      workout_template_id: push_template.id
    })

    # Multiple sets of triceps dips
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: push_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: push_template.id
    })

    # Pull Day (Back and Biceps)
    pull_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Pull Day (Back & Biceps)",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of pull-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: pull_template.id
    })

    # Multiple sets of seated rows
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 55.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: pull_template.id
    })

    # Multiple sets of barbell shrugs
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("barbell shrug").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell shrug").id,
      workout_template_id: pull_template.id
    })

    # Multiple sets of bicep curls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 10.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: pull_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 15.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: pull_template.id
    })

    # Leg Day
    leg_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Leg Day (Quads, Hamstrings, Glutes)",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of squats
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 60.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 90.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 100.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: leg_template.id
    })

    # Multiple sets of deadlifts
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 100.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 120.0,
      weight_unit: "kg",
      reps: 4,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: leg_template.id
    })

    # Multiple sets of walking lunges
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: leg_template.id
    })

    # Multiple sets of calf raises
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 30.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("weighted donkey calf raise").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 40.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("weighted donkey calf raise").id,
      workout_template_id: leg_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 50.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("weighted donkey calf raise").id,
      workout_template_id: leg_template.id
    })

    # ==================== 2. UPPER/LOWER SPLIT ====================

    # Upper Body Workout
    upper_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Upper Body Day",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of bench press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 30.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: upper_template.id
    })

    # Multiple sets of pull-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: upper_template.id
    })

    # Multiple sets of shoulder press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 15.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: upper_template.id
    })

    # Multiple sets of bicep curls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 15.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell curl").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 20.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell curl").id,
      workout_template_id: upper_template.id
    })

    # Multiple sets of triceps dips
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: upper_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: upper_template.id
    })

    # Lower Body Workout
    lower_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Lower Body Day",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of squats
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 60.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 100.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: lower_template.id
    })

    # Multiple sets of deadlifts
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 100.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 120.0,
      weight_unit: "kg",
      reps: 4,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: lower_template.id
    })

    # Multiple sets of front squats
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 50.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 60.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: lower_template.id
    })

    # Multiple sets of lunges
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: lower_template.id
    })

    # Core exercises
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("hanging leg raise").id,
      workout_template_id: lower_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("hanging leg raise").id,
      workout_template_id: lower_template.id
    })

    # ==================== 3. FULL BODY WORKOUT ====================

    full_body_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Full Body Workout",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of squats
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 60.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 90.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: full_body_template.id
    })

    # Multiple sets of bench press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 30.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: full_body_template.id
    })

    # Multiple sets of pull-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: full_body_template.id
    })

    # Multiple sets of shoulder press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 15.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("band shoulder press").id,
      workout_template_id: full_body_template.id
    })

    # Arm exercises
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: full_body_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: full_body_template.id
    })

    # Core exercise
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("russian twist").id,
      workout_template_id: full_body_template.id
    })

    # ==================== 4. BRO SPLIT ====================

    # Chest Day
    chest_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Chest Day (Bro Split)",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of bench press
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 30.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 35.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: chest_template.id
    })

    # Multiple sets of push-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: chest_template.id
    })

    # Multiple sets of chest dips
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("chest dip").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("chest dip").id,
      workout_template_id: chest_template.id
    })

    # Multiple sets of incline push-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("incline push-up").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("incline push-up").id,
      workout_template_id: chest_template.id
    })

    # Multiple sets of decline push-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("decline push-up").id,
      workout_template_id: chest_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("decline push-up").id,
      workout_template_id: chest_template.id
    })

    # Back Day
    back_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Back Day (Bro Split)",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of pull-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: back_template.id
    })

    # Multiple sets of chin-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("chin-up").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("chin-up").id,
      workout_template_id: back_template.id
    })

    # Multiple sets of seated rows
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 60.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: back_template.id
    })

    # Multiple sets of suspended rows
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("suspended row").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("suspended row").id,
      workout_template_id: back_template.id
    })

    # Multiple sets of barbell shrugs
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("barbell shrug").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell shrug").id,
      workout_template_id: back_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 60.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell shrug").id,
      workout_template_id: back_template.id
    })

    # Arms Day
    arms_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Arms Day (Bro Split)",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of barbell curls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 15.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell curl").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 20.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell curl").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 25.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell curl").id,
      workout_template_id: arms_template.id
    })

    # Multiple sets of dumbbell curls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 10.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 12.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell biceps curl").id,
      workout_template_id: arms_template.id
    })

    # Multiple sets of preacher curls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 10.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell preacher curl").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 12.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("dumbbell preacher curl").id,
      workout_template_id: arms_template.id
    })

    # Multiple sets of triceps dips
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: arms_template.id
    })

    # Multiple sets of bench dips
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("weighted bench dip").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 10.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("weighted bench dip").id,
      workout_template_id: arms_template.id
    })

    # Multiple sets of diamond push-ups
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("diamond push-up").id,
      workout_template_id: arms_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("diamond push-up").id,
      workout_template_id: arms_template.id
    })

    # ==================== 5. FUNCTIONAL FITNESS WORKOUT ====================

    functional_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Functional Fitness Workout",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Multiple sets of kettlebell swings
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 16.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 20.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 24.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of burpees
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of power cleans
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 60.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 70.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 80.0,
      weight_unit: "kg",
      reps: 4,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of thrusters
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell thruster").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("barbell thruster").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 60.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("barbell thruster").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of mountain climbers
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of bear crawls
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("bear crawl").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("bear crawl").id,
      workout_template_id: functional_template.id
    })

    # Multiple sets of kettlebell thrusters
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 8.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 10.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: functional_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 12.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: functional_template.id
    })

    # ==================== 6. 5x5 STRENGTH TRAINING PROGRAM ====================

    # 5x5 Workout A
    five_by_five_a =
      Repo.insert!(%WorkoutTemplate{
        name: "5x5 Strength Workout A",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Squats - 5 sets of 5 reps
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_a.id
    })

    # Bench Press - 5 sets of 5 reps (using dumbbell bench press as substitute)
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: five_by_five_a.id
    })

    # Rows - 5 sets of 5 reps (using cable seated row as substitute)
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: five_by_five_a.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("cable seated row").id,
      workout_template_id: five_by_five_a.id
    })

    # 5x5 Workout B
    five_by_five_b =
      Repo.insert!(%WorkoutTemplate{
        name: "5x5 Strength Workout B",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Squats - 5 sets of 5 reps
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: five_by_five_b.id
    })

    # Overhead Press - 5 sets of 5 reps
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: five_by_five_b.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: five_by_five_b.id
    })

    # Deadlift - 1 set of 5 reps
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 100.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: five_by_five_b.id
    })

    # ==================== 7. HIIT WORKOUT ====================

    hiit_template =
      Repo.insert!(%WorkoutTemplate{
        name: "HIIT (High Intensity Interval Training)",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Burpees - 4 sets of 30 seconds
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("burpee").id,
      workout_template_id: hiit_template.id
    })

    # Mountain Climbers - 4 sets of 30 seconds
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: hiit_template.id
    })

    # Kettlebell Swings - 4 sets of 30 seconds
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 16.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 16.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 16.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 16.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: hiit_template.id
    })

    # Jump Squats - 4 sets of 30 seconds
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("jump squat").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("jump squat").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("jump squat").id,
      workout_template_id: hiit_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("jump squat").id,
      workout_template_id: hiit_template.id
    })

    # ==================== 8. BODYWEIGHT WORKOUT ====================

    bodyweight_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Bodyweight Workout",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Push-ups - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("push-up").id,
      workout_template_id: bodyweight_template.id
    })

    # Pull-ups - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 6,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 4,
      check_box: false,
      exercise_id: get_exercise.("pull-up").id,
      workout_template_id: bodyweight_template.id
    })

    # Squats (bodyweight) - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      # Using same exercise but with 0 weight for bodyweight
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 25,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: bodyweight_template.id
    })

    # Lunges - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("walking lunge").id,
      workout_template_id: bodyweight_template.id
    })

    # Dips - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("triceps dip").id,
      workout_template_id: bodyweight_template.id
    })

    # Plank (treating as reps though it would be seconds) - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 60,
      check_box: false,
      # Using shoulder tap as a substitute for plank
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 45,
      check_box: false,
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: bodyweight_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: bodyweight_template.id
    })

    # ==================== 9. POWERLIFTING ROUTINE ====================

    powerlifting_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Powerlifting Training",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Squat - Pyramid sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 60.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 100.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 120.0,
      weight_unit: "kg",
      reps: 1,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 100.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell full squat").id,
      workout_template_id: powerlifting_template.id
    })

    # Bench Press - Pyramid sets (using dumbbell bench press)
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 30.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 35.0,
      weight_unit: "kg",
      reps: 1,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 25.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("dumbbell bench press").id,
      workout_template_id: powerlifting_template.id
    })

    # Deadlift - Pyramid sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 100.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 120.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 140.0,
      weight_unit: "kg",
      reps: 1,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: powerlifting_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 100.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: powerlifting_template.id
    })

    # ==================== 10. MOBILITY AND RECOVERY ====================

    mobility_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Mobility and Recovery Session",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Inchworm Stretch - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("inchworm").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("inchworm").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("inchworm").id,
      workout_template_id: mobility_template.id
    })

    # Iron Cross Stretch - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("iron cross stretch").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("iron cross stretch").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("iron cross stretch").id,
      workout_template_id: mobility_template.id
    })

    # Good Morning Stretch - 3 sets (using barbell good morning at low weight)
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell good morning").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell good morning").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 20.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("barbell good morning").id,
      workout_template_id: mobility_template.id
    })

    # Shoulder Taps/Plank - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("shoulder tap").id,
      workout_template_id: mobility_template.id
    })

    # Push-up to Side Plank - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("push-up to side plank").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("push-up to side plank").id,
      workout_template_id: mobility_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("push-up to side plank").id,
      workout_template_id: mobility_template.id
    })

    # ==================== 11. OLYMPIC WEIGHTLIFTING ====================

    olympic_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Olympic Weightlifting",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Power Clean - 5 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 50.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 60.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 70.0,
      weight_unit: "kg",
      reps: 2,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 5,
      weight: 75.0,
      weight_unit: "kg",
      reps: 1,
      check_box: false,
      exercise_id: get_exercise.("power clean").id,
      workout_template_id: olympic_template.id
    })

    # Front Squat - 4 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 50.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 60.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 70.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 80.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("barbell front squat").id,
      workout_template_id: olympic_template.id
    })

    # Clean Pull (using deadlift as substitute) - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 80.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 90.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 100.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("barbell deadlift").id,
      workout_template_id: olympic_template.id
    })

    # Overhead Press - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 40.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 45.0,
      weight_unit: "kg",
      reps: 5,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: olympic_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 50.0,
      weight_unit: "kg",
      reps: 3,
      check_box: false,
      exercise_id: get_exercise.("overhead press").id,
      workout_template_id: olympic_template.id
    })

    # ==================== 12. CORE FOCUSED WORKOUT ====================

    core_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Core Focused Workout",
        user_id: user2.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Hanging Leg Raises - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("hanging leg raise").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("hanging leg raise").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("hanging leg raise").id,
      workout_template_id: core_template.id
    })

    # Russian Twists - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("russian twist").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("russian twist").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("russian twist").id,
      workout_template_id: core_template.id
    })

    # Side Bends - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 15.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell side bend").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 15.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell side bend").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 15.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("dumbbell side bend").id,
      workout_template_id: core_template.id
    })

    # Mountain Climbers - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 30,
      check_box: false,
      exercise_id: get_exercise.("mountain climber").id,
      workout_template_id: core_template.id
    })

    # Decline Sit-ups - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("decline sit-up").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("decline sit-up").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("decline sit-up").id,
      workout_template_id: core_template.id
    })

    # Reverse Crunches - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("reverse crunch").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("reverse crunch").id,
      workout_template_id: core_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 0.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("reverse crunch").id,
      workout_template_id: core_template.id
    })

    # ==================== 13. KETTLEBELL WORKOUT ====================

    kettlebell_template =
      Repo.insert!(%WorkoutTemplate{
        name: "Kettlebell Circuit Workout",
        user_id: user1.id,
        is_finished: false,
        workout_template_score: 0
      })

    # Kettlebell Swings - 4 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 16.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 20.0,
      weight_unit: "kg",
      reps: 15,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 24.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 4,
      weight: 16.0,
      weight_unit: "kg",
      reps: 20,
      check_box: false,
      exercise_id: get_exercise.("kettlebell swing").id,
      workout_template_id: kettlebell_template.id
    })

    # Kettlebell Thrusters - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 12.0,
      weight_unit: "kg",
      reps: 12,
      check_box: false,
      exercise_id: get_exercise.("kettlebell thruster").id,
      workout_template_id: kettlebell_template.id
    })

    # Kettlebell Renegade Rows - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 16.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("kettlebell alternating renegade row").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 16.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("kettlebell alternating renegade row").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 16.0,
      weight_unit: "kg",
      reps: 10,
      check_box: false,
      exercise_id: get_exercise.("kettlebell alternating renegade row").id,
      workout_template_id: kettlebell_template.id
    })

    # Kettlebell Windmills - 3 sets
    Repo.insert!(%WorkoutItem{
      sets: 1,
      weight: 12.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("kettlebell windmill").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 2,
      weight: 12.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("kettlebell windmill").id,
      workout_template_id: kettlebell_template.id
    })

    Repo.insert!(%WorkoutItem{
      sets: 3,
      weight: 12.0,
      weight_unit: "kg",
      reps: 8,
      check_box: false,
      exercise_id: get_exercise.("kettlebell windmill").id,
      workout_template_id: kettlebell_template.id
    })

    IO.puts(
      "Successfully created 13 workout templates with proper set numbering for each exercise"
    )

    IO.puts(
      "Successfully created 5 workout templates with proper set numbering for each exercise"
    )
  end
end
