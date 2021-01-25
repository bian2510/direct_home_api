defmodule DirectHomeApiWeb.HealthControllerTest do
  use DirectHomeApiWeb.ConnCase

  describe "health_check" do
    test "returns server status", %{conn: conn} do
      conn = get(conn, Routes.health_path(conn, :health_check))
      assert %{"status" => "available"} = Jason.decode!(conn.resp_body)
      assert 200 = conn.status
    end
  end
end
