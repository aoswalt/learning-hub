# defmodule SocialAppApi.UserController do
#   use SocialAppApi.Web, :controller

#   alias SocialAppApi.User

#   plug(Guardian.Plug.EnsureAuthenticated, handler: SocialAppApi.AuthController)

#   def index(conn, _params) do
#     users = Repo.all(User)
#     render(conn, "index.json-api", data: users)
#   end

#   def current(conn, _) do
#     user = conn |> Guardian.Plug.current_resource()

#     conn |> render(SocialAppApi.UserView, "show.json-api", data: user)
#   end
# end
