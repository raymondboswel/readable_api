defmodule ReadableApiWeb.API.V1.UserSessionController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Accounts
  alias ReadableApiWeb.UserAuth

  # @session_max_age 60 * 60 * 1
  # @remember_max_age 60 * 60 *24 * 14
  @session_max_age 60
  @remember_max_age 60 * 4

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params
    user = Accounts.get_user_by_email_and_password(email, password)
    cond do
      user == nil ->
        conn
        |> put_status(401)
        |> render("auth_fail.json", error_message: "Invalid email or password")
      user != nil and user.confirmed_at == nil ->
        conn
        |> put_status(422)
        |> render("auth_fail.json", error_message: "Please confirm your email address and try again")
      user ->
        token = Accounts.generate_user_session_token(user)
        jwt = jwt(token)
        IO.inspect jwt
        conn
          |> UserAuth.maybe_write_remember_me_cookie(token, user_params)
          |> UserAuth.write_auth_cookie(token)
          |> render("auth_success.json", token: jwt)
    end
  end

  def renew do

  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end

  defp jwt(token) do
    extra_claims = %{ "token" => Base.encode64(token)}
    IO.inspect Base.encode64(token)
    token_with_default_plus_custom_claims = ReadableApi.Token.generate_and_sign!(extra_claims)
  end
end
