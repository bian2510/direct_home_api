defmodule DirectHomeApiWeb.HealthControllerTest do
  describe "health_check" do
    test "returns server status", %{conn: conn} do
      conn = get(conn, Routes.health_path(conn, :health_check))
      assert json_response(conn, 200) == 'available'
    end
  end
end
