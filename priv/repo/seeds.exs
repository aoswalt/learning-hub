# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hub.RepoDB.insert!(%Hub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

names =
  [
    "Adam",
    "Amy",
    "Bobby",
    "Dominic",
    "Frank",
    "Geoff",
    "James",
    "Jane",
    "Jimbo",
    "John",
    "Manila",
    "Matt",
    "Rich",
    "Rick",
    "Rose",
    "Sarah",
    "Steve",
    "Will"
  ]
  |> Enum.shuffle()

cohort_prefixes = [{"", 0.90}, {"E", 0.08}, {"DS", 0.02}]

bios =
  [
    "International (wo)man of mystery",
    "Coined the phrase 'coin the phrase'",
    "Divides by zero",
    "Sold a comb to a bald man",
    "Compiles on the first try",
    "Hacked the matrix",
    "Knows a thing or 2",
    "Did the thing with the stuff"
  ]
  |> Enum.shuffle()

questions =
  [
    "How do I Vim?",
    "Wtf is a hook?!",
    "Help, I injected SQL into my veins!",
    "Why do you work different here?",
    "Attempting to go back in time and prevent the creation of sql",
    "It broke",
    "How do I do the thing?"
  ]
  |> Enum.shuffle()

answers =
  [
    "You ask Adam",
    "Learn the matrix",
    "Try :Tutor in Neovim",
    "Reserved for later",
    "Time to reformat",
    "Install Linux",
    "Are permissions correct?",
    "Check out my github repo to see the future",
    "git gud",
    "Do the thing",
    "Option C works better",
    "alt+F4"
  ]
  |> Enum.shuffle()

tags = %{
  ajax: "Ajax",
  android: "Android",
  angular: "Angular",
  angularjs: "AngularJS",
  arrays: "Arrays",
  asp_dotnet: "ASP.NET",
  asp_dotnet_mvc: "ASP.NET MVC",
  bash: "Bash",
  c: "C",
  c_sharp: "C#",
  cpp: "C++",
  css: "CSS",
  database: "Database",
  django: "Django",
  dotnet: ".NET",
  eclipse: "Eclipse",
  elixir: "Elixir",
  excel: "Excel",
  git: "Git",
  html: "HTML",
  ios: "IOS",
  iphone: "iPhone",
  java: "Java",
  javascript: "JavaScript",
  jquery: "jQuery",
  json: "JSON",
  laravel: "Laravel",
  linux: "Linux",
  mongodb: "MongoDB",
  multithreading: "Multithreading",
  mysql: "MYSQL",
  node: "Node.js",
  objective_c: "Objective C",
  oracle: "Oracle",
  pandas: "Pandas",
  php: "PHP",
  postgresql: "Postgresql",
  python: "Python",
  r: "R",
  react: "Reactjs",
  regex: "Regex",
  ruby: "Ruby",
  rails: "Ruby On Rails",
  spring: "Spring",
  sql: "SQL",
  sql_server: "SQL Server",
  string: "String",
  swift: "Swift",
  vb_dotnet: "VB.NET",
  vba: "VBA",
  vim: "vim",
  windows: "Windows",
  wordpress: "Wordpress",
  wpf: "WPF",
  xcode: "Xcode",
  xml: "XML"
}

get_weighted = fn options ->
  Enum.reduce_while(options, :random.uniform(), fn {element, chance}, num ->
    remaining = num - chance
    if remaining <= 0, do: {:halt, element}, else: {:cont, remaining}
  end)
end

unpack_result = fn result ->
  case result do
    {:ok, ok} ->
      ok

    {:error, %Ecto.Changeset{} = changeset} ->
      raise Ecto.InvalidChangesetError, changeset: changeset

    {:error, error} ->
      raise error
  end
end

get_random_tags = fn max ->
  0..:random.uniform(max)
  |> Enum.map(fn _ ->
    tags
    |> Map.keys()
    |> Enum.random()
    |> Atom.to_string()
  end)
end

# add profiles
user_ids =
  bios
  |> Enum.zip(names)
  |> Enum.map(fn {bio, name} ->
    cohort_prefix = get_weighted.(cohort_prefixes)
    cohort_num = 50 |> :random.uniform() |> Integer.to_string()

    %{
      name: name,
      cohort: cohort_prefix <> cohort_num,
      tags: get_random_tags.(6),
      bio: bio,
      user_id: 0..7 |> Enum.map(fn _ -> Enum.random(?a..?z) end) |> to_string()
    }
  end)
  |> Enum.map(&Hub.create_profile/1)
  |> Enum.map(unpack_result)
  |> Enum.map(& &1.user_id)

# add questions
question_ids =
  questions
  |> Enum.map(
    &%{
      text: &1,
      tags: get_random_tags.(3),
      created_by: Enum.random(user_ids)
    }
  )
  |> Enum.map(&Hub.create_question/1)
  |> Enum.map(unpack_result)
  |> Enum.map(& &1.id)

# add answers
answered_questions =
  answers
  |> Enum.map(
    &%{
      text: &1,
      created_by: Enum.random(user_ids),
      question_id: Enum.random(question_ids)
    }
  )
  |> Enum.map(&Hub.create_answer/1)
  |> Enum.map(unpack_result)

# set solutions
answered_questions
|> Enum.group_by(& &1.question_id)
|> Enum.reject(fn _ -> :random.uniform() < 0.2 end)
|> Enum.map(fn {q_id, ans_list} -> {q_id, List.first(ans_list)} end)
|> Enum.map(fn {q_id, ans} ->
  q_id
  |> Hub.get_question!()
  |> Hub.update_question(%{solution_id: ans.id})
end)
|> Enum.map(unpack_result)
