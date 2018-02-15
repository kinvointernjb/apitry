defmodule ApitryWeb.UserView do
  use ApitryWeb, :view
  alias ApitryWeb.UserView
  alias ApitryWeb.PostView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}

  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      password: user.password,
      posts: render_many(user.posts, PostView, "post.json")}
  end
end
