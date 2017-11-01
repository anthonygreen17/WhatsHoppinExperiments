defmodule ExperimentTwo.BeerTest do
  use ExperimentTwo.DataCase

  alias ExperimentTwo.Beer

  describe "styles" do
    alias ExperimentTwo.Beer.Style

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def style_fixture(attrs \\ %{}) do
      {:ok, style} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Beer.create_style()

      style
    end

    test "list_styles/0 returns all styles" do
      style = style_fixture()
      assert Beer.list_styles() == [style]
    end

    test "get_style!/1 returns the style with given id" do
      style = style_fixture()
      assert Beer.get_style!(style.id) == style
    end

    test "create_style/1 with valid data creates a style" do
      assert {:ok, %Style{} = style} = Beer.create_style(@valid_attrs)
      assert style.name == "some name"
    end

    test "create_style/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Beer.create_style(@invalid_attrs)
    end

    test "update_style/2 with valid data updates the style" do
      style = style_fixture()
      assert {:ok, style} = Beer.update_style(style, @update_attrs)
      assert %Style{} = style
      assert style.name == "some updated name"
    end

    test "update_style/2 with invalid data returns error changeset" do
      style = style_fixture()
      assert {:error, %Ecto.Changeset{}} = Beer.update_style(style, @invalid_attrs)
      assert style == Beer.get_style!(style.id)
    end

    test "delete_style/1 deletes the style" do
      style = style_fixture()
      assert {:ok, %Style{}} = Beer.delete_style(style)
      assert_raise Ecto.NoResultsError, fn -> Beer.get_style!(style.id) end
    end

    test "change_style/1 returns a style changeset" do
      style = style_fixture()
      assert %Ecto.Changeset{} = Beer.change_style(style)
    end
  end

  describe "messages" do
    alias ExperimentTwo.Beer.Message

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Beer.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Beer.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Beer.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Beer.create_message(@valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Beer.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Beer.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Beer.update_message(message, @invalid_attrs)
      assert message == Beer.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Beer.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Beer.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Beer.change_message(message)
    end
  end
end
