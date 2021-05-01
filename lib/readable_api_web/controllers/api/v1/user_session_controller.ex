defmodule ReadableApiWeb.API.V1.UserSessionController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Accounts
  alias ReadableApiWeb.UserAuth

  @session_max_age Application.get_env(:readable_api, :session, :session_max_age)
  @remember_max_age Application.get_env(:readable_api, :session, :remember_max_age)

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
        |> render("auth_fail.json",
          error_message: "Please confirm your email address and try again"
        )

      user ->
        token = Accounts.generate_user_session_token(user)
        jwt = jwt(token)
        refresh_jwt = refresh_jwt(token)

        conn
        |> UserAuth.maybe_write_remember_me_cookie(token, user_params)
        |> UserAuth.write_auth_cookie(token)
        |> render("auth_success.json", token: jwt, refresh_token: refresh_jwt)
    end
  end

  def renew(conn, _) do
    auth_header = get_req_header(conn, "authorization")
    header = List.first(auth_header)

    enc_token =
      case ReadableApi.RefreshToken.verify_and_validate(header) do
        {:ok, %{"token" => token}} ->
          token

        _ ->
          nil
      end

    token = Base.decode64!(enc_token)
    user = Accounts.get_user_by_session_token(token)
    Accounts.delete_session_token(token)
    user_token = Accounts.generate_user_session_token(user)

    jwt = jwt(user_token)
    refresh_jwt = refresh_jwt(token)

    conn
    |> render("auth_success.json", token: jwt, refresh_token: refresh_jwt)
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end

  defp jwt(token) do
    extra_claims = %{"token" => Base.encode64(token)}
    token_with_claims = ReadableApi.Token.generate_and_sign!(extra_claims)
  end

  defp refresh_jwt(token) do
    extra_claims = %{"token" => Base.encode64(token)}
    token_with_claims = ReadableApi.RefreshToken.generate_and_sign!(extra_claims)
  end
end
