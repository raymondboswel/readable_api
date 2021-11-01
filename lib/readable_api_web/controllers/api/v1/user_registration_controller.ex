defmodule ReadableApiWeb.API.V1.UserRegistrationController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Accounts
  alias ReadableApi.Accounts.User
  alias ReadableApiWeb.UserAuth
  require Logger

  action_fallback ReadableApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        # TODO: Send message in response explaining required email confirmation
        res = conn
          |> send_resp(200, "")
    end
  end
end
