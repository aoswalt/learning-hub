# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hub.Repo.insert!(%Hub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, %{id: aa, user_id: a}} =  %Hub.Profile{} |> Hub.Profile.changeset(%{name: "Rich", cohort: "E8", bio: "International man of mystery", user_id: "asdsadhjk1", tags: ["javascript"]}) |> Hub.Repo.insert()

{:ok, %{id: bb, user_id: b}} =  %Hub.Profile{} |> Hub.Profile.changeset(%{name: "Matt", cohort: "33", bio: "Coined the phrase 'coin the phrase'", user_id: "dsfhkjh342", tags: ["python"]}) |> Hub.Repo.insert()

{:ok, %{id: cc, user_id: c}} =  %Hub.Profile{} |> Hub.Profile.changeset(%{name: "Will", cohort: "34", bio: "Compiles on the first try", user_id: "34809dfjsdfk", tags: ["c#"]}) |> Hub.Repo.insert()

{:ok, %{id: dd, user_id: d}} =  %Hub.Profile{} |> Hub.Profile.changeset(%{name: "Adam", cohort: "13", bio: "Divides by zero", user_id: "867asdfjdk", tags: ["elixir"]}) |> Hub.Repo.insert()

{:ok, %{id: ee, user_id: e}} =  %Hub.Profile{} |> Hub.Profile.changeset(%{name: "Bobby", cohort: "34", bio: "Sold a comb to a bald man", user_id: "458978sdfhjkh", tags: ["react"]}) |> Hub.Repo.insert()


{:ok, %{id: f}} =  %Hub.Question{} |> Hub.Question.changeset(%{text: "How do I Vim", created_at: "2019-10-26", created_by: e, tags: ["elixir"]}) |> Hub.Repo.insert()

{:ok, %{id: g}} =  %Hub.Question{} |> Hub.Question.changeset(%{text: "Wtf is a hook", created_at: "2019-10-25", created_by: a, tags: ["react", "javascript"]}) |> Hub.Repo.insert()

{:ok, %{id: h}} =  %Hub.Question{} |> Hub.Question.changeset(%{text: "Help, I injected SQL into my veins", created_at: "2019-09-24", created_by: a, tags: ["c#", "sql"]}) |> Hub.Repo.insert()

{:ok, %{id: j}} =  %Hub.Question{} |> Hub.Question.changeset(%{text: "If postgres doesn't work with docker someone might have to die.", created_at: "2018-07-13", created_by: d, tags: ["postgresql"]}) |> Hub.Repo.insert()

{:ok, %{id: k}} =  %Hub.Question{} |> Hub.Question.changeset(%{text: "Attempting to go back in time and prevent the creation of sql", created_at: "2019-04-20", created_by: b, tags: ["sql"]}) |> Hub.Repo.insert()


{:ok, %{id: l}} =  %Hub.Answer{} |> Hub.Answer.changeset(%{text: "You ask Adam", created_at: "2019-10-27", created_by: a, question_id: f}) |> Hub.Repo.insert()

{:ok, %{id: m}} =  %Hub.Answer{} |> Hub.Answer.changeset(%{text: "Reserved for later", created_at: "2019-10-26", created_by: b, question_id: g}) |> Hub.Repo.insert()

{:ok, %{id: n}} =  %Hub.Answer{} |> Hub.Answer.changeset(%{text: "Time to reformat", created_at: "2019-09-27", created_by: c, question_id: h}) |> Hub.Repo.insert()

{:ok, %{id: o}} =  %Hub.Answer{} |> Hub.Answer.changeset(%{text: "Install Linux", created_at: "2018-10-11", created_by: e, question_id: j}) |> Hub.Repo.insert()

{:ok, %{id: p}} =  %Hub.Answer{} |> Hub.Answer.changeset(%{text: "Check out my github repo to see the future", created_at: "2019-10-27", created_by: d, question_id: f}) |> Hub.Repo.insert()
