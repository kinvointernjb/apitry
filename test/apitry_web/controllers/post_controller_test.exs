defmodule ApitryWeb.PostControllerTest do
  use ApitryWeb.ConnCase

  alias Apitry.Blog
  alias Apitry.Accounts
  alias Apitry.Blog.Post

  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(%{password: "some password", username: "some username"})
    user
  end

  def fixture(user, :post) do
    {:ok, post} = Blog.create_post(user.id, @create_attrs)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all posts", %{conn: conn} do
      conn = get conn, user_post_path(conn, :index, conn.assigns.user.id)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    setup [:create_user]

    test "renders post when data is valid", %{conn: conn} do
      conn = post conn, user_post_path(conn, :create, conn.assigns.user.id), post: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_post_path(conn, :show, conn.assigns.user.id, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "some content",
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_post_path(conn, :create, conn.assigns.user.id), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post, user: user} do
      conn = put conn, user_post_path(conn, :update, user.id, post), post: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_post_path(conn, :show, user.id, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "some updated content",
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn = put conn, user_post_path(conn, :update, user.id, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post, user: user} do
      conn = delete conn, user_post_path(conn, :delete, user.id, post)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_post_path(conn, :show, user.id, post)
      end
    end
  end

  defp create_post(_) do
    user = fixture(:user)
    post = fixture(user, :post)
    {:ok, post: post, user: user}
  end

  defp create_user(%{conn: conn}) do
    user = fixture(:user)
    {:ok, conn: assign(conn, :user, user)}
  end
end
