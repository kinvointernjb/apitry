defmodule ApitryWeb.PostController do
  use ApitryWeb, :controller

  alias Apitry.Blog
  alias Apitry.Blog.Post

  action_fallback ApitryWeb.FallbackController

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"user_id" => user_id, "post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.create_post(user_id |> String.to_integer, post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_post_path(conn, :show, user_id, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"user_id" => _user_id, "id" => id}) do
    post = Blog.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)

    with {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    with {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
