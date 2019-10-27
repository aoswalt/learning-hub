defmodule HubWeb.AuthController do
  use HubWeb, :controller

  # alias Ueberauth.Strategy.Helpers

  # plug Ueberauth


  def validate(conn, %{"code" => code}) do
    token = Ueberauth.Strategy.Slack.OAuth.get_token!([code: code])

  # %OAuth2.AccessToken{
  #   access_token: nil,
  #   expires_at: nil,
  #   other_params: %{"error" => "invalid_code", "ok" => false},
  #   refresh_token: nil,
  #   token_type: "Bearer"
  # }

    render(conn, "token.json", token: token.access_token)
  end

#   def request(conn, %{"provider" => "slack"}) do
#     # client = Application.get_env(:ueberauth, Ueberauth.Strategy.Slack.OAuth) |>
#     render(conn, "request.json", callback_url: Helpers.callback_url(conn))
#   end

#     def delete(conn, _params) do
#     conn
#     |> put_flash(:info, "You have been logged out!")
#     |> configure_session(drop: true)
#     |> redirect(to: "/")
#   end

#   def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
#     conn
#     |> put_flash(:error, "Failed to authenticate.")
#     |> redirect(to: "/")
#   end

#   def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
#     case UserFromAuth.find_or_create(auth) do
#       {:ok, user} ->
#         conn
#         |> put_flash(:info, "Successfully authenticated.")
#         |> put_session(:current_user, user)
#         |> configure_session(renew: true)
#         |> redirect(to: "/")
#       {:error, reason} ->
#         conn
#         |> put_flash(:error, reason)
#         |> redirect(to: "/")
#     end
#   end
end

# defmodule SocialAppApi.AuthController do
#   use SocialAppApi.Web, :controller
#   plug(Ueberauth)

#   alias SocialAppApi.User
#   alias MyApp.UserQuery

#   plug(:scrub_params, "user" when action in [:sign_in_user])

#   def request(_params) do
#   end

#   # Sign out the user
#   def delete(conn, _params) do
#     conn
#     |> put_status(200)
#     |> Guardian.Plug.sign_out(conn)
#   end

#   def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
#     # This callback is called when the user denies the app to get the data from the oauth provider
#     conn
#     |> put_status(401)
#     |> render(SocialAppApi.ErrorView, "401.json-api")
#   end

#   def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
#     case AuthUser.basic_info(auth) do
#       {:ok, user} -> sign_in_user(conn, %{"user" => user})
#     end

#     case AuthUser.basic_info(auth) do
#       {:ok, user} -> conn |> render(SocialAppApi.UserView, "show.json-api", %{data: user})
#       {:error} -> conn |> put_status(401) |> render(SocialAppApi.ErrorView, "401.json-api")
#     end
#   end

#   def sign_in_user(conn, %{"user" => user}) do
#     try do
#       # Attempt to retrieve exactly one user from the DB, whose
#       # email matches the one provided with the login request
#       user =
#         User
#         |> where(email: ^user.email)
#         |> Repo.one!()

#       cond do
#         # Successful login          # Encode a JWT
#         true ->
#           {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
#           auth_conn = Guardian.Plug.api_sign_in(conn, user)
#           jwt = Guardian.Plug.current_token(auth_conn)
#           {:ok, claims} = Guardian.Plug.claims(auth_conn)

#           auth_conn
#           |> put_resp_header("authorization", "Bearer #{jwt}")
#           # Return token to the client
#           |> json(%{access_token: jwt})

#         # Unsuccessful login
#         false ->
#           conn
#           |> put_status(401)
#           |> render(SocialAppApi.ErrorView, "401.json-api")
#       end
#     rescue
#       # Print error to the console for debugging
#       e ->
#         IO.inspect(e)
#         # Successful registration
#         sign_up_user(conn, %{"user" => user})
#     end
#   end

#   def sign_up_user(conn, %{"user" => user}) do
#     changeset =
#       User.changeset(%User{}, %{
#         email: user.email,
#         avatar: user.avatar,
#         first_name: user.first_name,
#         last_name: user.last_name,
#         auth_provider: "google"
#       })

#     case Repo.insert(changeset) do
#       # Encode a JWT
#       {:ok, user} ->
#         {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

#         conn
#         |> put_resp_header("authorization", "Bearer #{jwt}")
#         # Return token to the client
#         |> json(%{access_token: jwt})

#       {:error, changeset} ->
#         conn
#         |> put_status(422)
#         |> render(SocialAppApi.ErrorView, "422.json-api")
#     end
#   end

#   def unauthenticated(conn, params) do
#     conn |> put_status(401) |> render(SocialAppApi.ErrorView, "401.json-api")
#   end

#   def unauthorized(conn, params) do
#     conn |> put_status(403) |> render(SocialAppApi.ErrorView, "403.json-api")
#   end

#   def already_authenticated(conn, params) do
#     conn |> put_status(200) |> render(SocialAppApi.ErrorView, "200.json-api")
#   end

#   def no_resource(conn, params) do
#     conn |> put_status(404) |> render(SocialAppApi.ErrorView, "404.json-api")
#   end
# end
