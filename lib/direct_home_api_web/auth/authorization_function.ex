defmodule DirectHomeApiWeb.Auth.AuthorizationFunction do
    def get_token_from_request(conn) do
    conn.req_headers 
    |> Enum.find(fn header -> elem(header, 0) == "authorization" end) |> elem(1) |> String.replace_leading("Bearer ", "")
    end
end