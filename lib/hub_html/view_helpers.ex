defmodule HubHTML.ViewHelpers do
  alias HubHTML.SharedView

  def shared(template, assigns \\ []) do
    SharedView.render("#{template}.html", assigns)
  end

  def shared(template, assigns, do: block) do
    shared(template, Keyword.merge(assigns, do: block))
  end

  def tags(values, deletable? \\ false) when is_list(values) do
    kw =
      if Keyword.keyword?(values), do: values, else: Enum.map(values, &{&1, HubDB.Tag.label!(&1)})

    shared(:chips, values: kw, deletable?: deletable?)
  end
end
