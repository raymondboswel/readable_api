defmodule ReadableApiWeb.API.V1.UserSessionController do
  use ReadableApiWeb, :controller

  alias ReadableApi.Accounts
  alias ReadableApiWeb.UserAuth

  @session_max_age 60 * 60 * 1
  @remember_max_age 60 * 60 *24 * 14

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params
    user = Accounts.get_user_by_email_and_password(email, password)
    cond do
      user != nil and user.confirmed_at == nil ->
        conn
        |> put_status(422)
        |> render("auth_fail.json", error_message: "Please confirm your email address and try again")
      user ->

      token = Accounts.generate_user_session_token(user)

      # remember_me_expiry = Timex.today() |> Timex.shift(weeks: 2) |> Timex.format!("{ISO:Extended:Z}")
      # session_expiry = = Timex.today() |> Timex.shift(hours: 2) |> Timex.format!("{ISO:Extended:Z}")

      conn = if Map.has_key?(user_params, "remember_me") && user_params["remember_me"] == true do
        conn
        |> put_resp_cookie("app-remember-me", %{token: token}, max_age: @remember_max_age, http_only: true, domain: "readable_api.ai", sign: true)
        |> put_resp_cookie("app-remember-me-local", %{token: token}, max_age: @remember_max_age, http_only: true, domain: "localhost", sign: true)
      else
        conn
      end

       conn
        |> put_resp_cookie("app-auth", %{token: token}, max_age: @session_max_age, http_only: true, domain: "readable_api.ai", sign: true)
        |> put_resp_cookie("app-auth-local", %{token: token}, max_age: @session_max_age, http_only: true, domain: "localhost", sign: true)
        |> send_resp(200, "")
      user == nil ->
        conn
        |> put_status(401)
        |> render("auth_fail.json", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> UserAuth.log_out_user()
  end
end
