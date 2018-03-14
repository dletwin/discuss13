defmodule DiscussWeb.UserController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Accounts
  alias Discuss.Accounts.User
  alias Discuss.Repo

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.html", users: users)
  # end

  # def new(conn, _params) do
  #   changeset = Accounts.change_user(%User{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   case Accounts.create_user(user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> redirect(to: topic_path(conn, :index))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   render(conn, "show.html", user: user)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   changeset = Accounts.change_user(user)
  #   render(conn, "edit.html", user: user, changeset: changeset)
  # end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do

      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: topic_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
      |> configure_session(drop: true)
      |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do

    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "Welcome, back!")
          |> put_session(:user_id, user.id)
          |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
          |> put_flash(:error, "Error signing in")
          |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
