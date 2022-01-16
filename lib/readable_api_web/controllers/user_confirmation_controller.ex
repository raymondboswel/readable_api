defmodule ReadableApiWeb.UserConfirmationController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: "/")
  end

  def confirm_test(conn, _params) do
    IO.inspect("Confirm test hit")
    IO.inspect(System.get_env("FRONTEND_URL"))

    conn
    |> render("confirmation.html", %{url: System.get_env("FRONTEND_URL"), already_confirmed: true})
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    IO.inspect("Confirm hit")

    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> render("confirmation.html", %{
          url: System.get_env("FRONTEND_URL"),
          already_confirmed: false
        })

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        conn
        |> render("confirmation.html", %{
          url: System.get_env("FRONTEND_URL"),
          already_confirmed: true
        })
    end
  end
end
