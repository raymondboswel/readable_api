defmodule PhoenixTemplateWeb.API.V1.UserRegistrationController do
  use PhoenixTemplateWeb, :controller

  alias PhoenixTemplate.Accounts
  alias PhoenixTemplate.Accounts.User
  alias PhoenixTemplateWeb.UserAuth

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        # TODO: Send message in response explaining required email confirmation
        res = conn
          |> send_resp(200, "")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
