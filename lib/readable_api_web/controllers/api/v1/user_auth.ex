defmodule ReadableApiWeb.UserAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias ReadableApi.Accounts
  alias ReadableApiWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in UserToken.

  @session_max_age Application.get_env(:readable_api, :session, :session_max_age)
  @remember_max_age Application.get_env(:readable_api, :session, :remember_max_age)


  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  # def log_in_user(conn, user, params \\ %{}) do
  #   token = Accounts.generate_user_session_token(user)
  #   user_return_to = get_session(conn, :user_return_to)

  #   conn
  #   |> renew_session()
  #   |> put_session(:user_token, token)
  #   |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  #   |> maybe_write_remember_me_cookie(token, params)
  #   |> redirect(to: user_return_to || signed_in_path(conn))
  # end

  def maybe_write_remember_me_cookie(conn, token, %{"remember_me" => true}) do
    write_remember_me_cookie(conn, token)
  end

  def write_remember_me_cookie(conn, token) do
    conn
    |> put_resp_cookie("app-remember-me", %{token: token}, max_age: @remember_max_age, http_only: true, domain: "readable.ai", sign: true)
  end

  def maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  def write_auth_cookie(conn, token) do
    conn
    |> put_resp_cookie("app-auth", %{token: token}, same_site: "Lax", max_age: @session_max_age, http_only: true, domain: "readable.ai", sign: true)
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    user_token = get_token_from_cookie(conn)
    user_token && Accounts.delete_session_token(user_token)

    # TODO: Make this work for live views as well
    # if live_socket_id = get_session(conn, :live_socket_id) do
    #   ReadableApiWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    # end

    conn
    |> send_resp(:ok, "")
    # TODO: Figure out "remember me" / refresh token functionality.
    # |> renew_session()
    # |> delete_resp_cookie(@remember_me_cookie)
    # |> redirect(to: "/")
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    conn = fetch_cookies(conn, signed: ~w(app-auth app-auth-local app-remember-me app-remember-me-local))
    auth_cookie = conn.cookies["app-auth"] || conn.cookies["app-auth-local"]
    auth_header = get_req_header(conn, "authorization")
    if is_nil(auth_cookie) do
      handle_header_auth(conn, auth_header)
    else
      handle_cookie_auth(conn, auth_cookie)
    end
  end

  defp handle_header_auth(conn, auth_header = []) do
    assign(conn, :current_user, nil)
  end

  defp handle_header_auth(conn, auth_header) do
    IO.inspect auth_header
    header = List.first(auth_header)
    user = case ReadableApi.Token.verify_and_validate(header) do
      {:ok, %{"token" => token}} ->
        token && Accounts.get_user_by_session_token(Base.decode64!(token))
      _ ->
        nil
      end
    assign(conn, :current_user, user)
  end

  defp handle_cookie_auth(conn, auth_cookie) do
    if is_nil(auth_cookie) do
      # refresh if possible
      remember_cookie = conn.cookies["app-remember-me"] || conn.cookies["app-remember-me-local"]
      if not is_nil(remember_cookie) do
        user_token = remember_cookie.token
        user = user_token && Accounts.get_user_by_session_token(user_token)
        # If user refreshes using refresh token, reset both auth and refresh tokens
        # Invalidate current session token before issueing new one
        Accounts.delete_session_token(user_token)
        user_token = Accounts.generate_user_session_token(user)
        assign(conn, :current_user, user)
        |> write_remember_me_cookie(user_token)
        |> write_auth_cookie(user_token)
      else
        conn
      end
    else
      user_token = auth_cookie.token
      user = user_token && Accounts.get_user_by_session_token(user_token)
      # Renew cookie on every request to implement "sliding session"
      assign(conn, :current_user, user)
      |> put_resp_cookie("app-auth", %{token: user_token}, max_age: @session_max_age, http_only: true, domain: "readable.ai", sign: true)
    end
  end

  defp get_token_from_cookie(conn) do
    conn = fetch_cookies(conn, signed: ~w(app-auth app-auth-local))
    IO.inspect conn
    # IO.inspect conn.cookies["app-auth"].token

    auth_cookie = conn.cookies["app-auth"] || conn.cookies["app-auth-local"]
    if is_nil(auth_cookie) do
      nil
    else
      auth_cookie.token
    end
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(ReadableApiWeb.API.V1.ErrorView)
      |> Phoenix.Controller.render("401.json")
      |> halt()

    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: "/"
end
