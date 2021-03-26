defmodule PhoenixTemplateWeb.API.V1.UserSessionController do
  use PhoenixTemplateWeb, :controller

  alias PhoenixTemplate.Accounts
  alias PhoenixTemplateWeb.UserAuth

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
        res = conn
        |> put_resp_cookie("app-auth", %{token: token}, http_only: true, domain: "phoenix_template.ai", sign: true)
        |> put_resp_cookie("app-auth-local", %{token: token}, http_only: true, domain: "localhost", sign: true)
        |> send_resp(200, "")
      user == nil ->
        conn
        |> put_status(401)
        |> render("auth_fail.json", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
