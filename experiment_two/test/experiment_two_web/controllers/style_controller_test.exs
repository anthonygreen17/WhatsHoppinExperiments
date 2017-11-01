defmodule ExperimentTwoWeb.StyleControllerTest do
  use ExperimentTwoWeb.ConnCase

  alias ExperimentTwo.Beer

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:style) do
    {:ok, style} = Beer.create_style(@create_attrs)
    style
  end

  describe "index" do
    test "lists all styles", %{conn: conn} do
      conn = get conn, style_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Styles"
    end
  end

  describe "new style" do
    test "renders form", %{conn: conn} do
      conn = get conn, style_path(conn, :new)
      assert html_response(conn, 200) =~ "New Style"
    end
  end

  describe "create style" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, style_path(conn, :create), style: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == style_path(conn, :show, id)

      conn = get conn, style_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Style"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, style_path(conn, :create), style: @invalid_attrs
      assert html_response(conn, 200) =~ "New Style"
    end
  end

  describe "edit style" do
    setup [:create_style]

    test "renders form for editing chosen style", %{conn: conn, style: style} do
      conn = get conn, style_path(conn, :edit, style)
      assert html_response(conn, 200) =~ "Edit Style"
    end
  end

  describe "update style" do
    setup [:create_style]

    test "redirects when data is valid", %{conn: conn, style: style} do
      conn = put conn, style_path(conn, :update, style), style: @update_attrs
      assert redirected_to(conn) == style_path(conn, :show, style)

      conn = get conn, style_path(conn, :show, style)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, style: style} do
      conn = put conn, style_path(conn, :update, style), style: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Style"
    end
  end

  describe "delete style" do
    setup [:create_style]

    test "deletes chosen style", %{conn: conn, style: style} do
      conn = delete conn, style_path(conn, :delete, style)
      assert redirected_to(conn) == style_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, style_path(conn, :show, style)
      end
    end
  end

  defp create_style(_) do
    style = fixture(:style)
    {:ok, style: style}
  end
end
