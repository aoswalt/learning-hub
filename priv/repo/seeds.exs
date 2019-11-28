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

alias HubDB.Repo

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
    HubDB.Tag.__enum_map__()
    |> Keyword.keys()
    |> Enum.random()
    |> Atom.to_string()
  end)
end

# add users
user_ids =
  bios
  |> Enum.map(fn _ ->
    %HubDB.User{}
    |> Ecto.Changeset.change()
    |> HubDB.Repo.insert()
  end)
  |> Enum.map(unpack_result)
  |> Enum.map(&Map.get(&1, :id))

# add profiles
user_ids
|> Enum.zip(bios)
|> Enum.zip(names)
|> Enum.map(fn {{user_id, bio}, name} ->
  cohort_prefix = get_weighted.(cohort_prefixes)
  cohort_num = 50 |> :random.uniform() |> Integer.to_string()

  %{
    name: name,
    cohort: cohort_prefix <> cohort_num,
    tags: get_random_tags.(6),
    bio: bio,
    user_id: user_id
  }
end)
|> Enum.map(&Hub.create_profile/1)
|> Enum.map(unpack_result)

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
  HubDB.Question
  |> Repo.get!(q_id)
  |> Hub.update_question(%{solution_id: ans.id})
end)
|> Enum.map(unpack_result)
