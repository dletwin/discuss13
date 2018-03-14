defmodule Discuss.PostsTest do
  use Discuss.DataCase

  alias Discuss.Posts

  describe "topics" do
    alias Discuss.Posts.Topic

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Posts.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Posts.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Posts.create_topic(@valid_attrs)
      assert topic.title == "some title"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, topic} = Posts.update_topic(topic, @update_attrs)
      assert %Topic{} = topic
      assert topic.title == "some updated title"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_topic(topic, @invalid_attrs)
      assert topic == Posts.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Posts.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Posts.change_topic(topic)
    end
  end

  describe "comment" do
    alias Discuss.Posts.Comments

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def comments_fixture(attrs \\ %{}) do
      {:ok, comments} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_comments()

      comments
    end

    test "list_comment/0 returns all comment" do
      comments = comments_fixture()
      assert Posts.list_comment() == [comments]
    end

    test "get_comments!/1 returns the comments with given id" do
      comments = comments_fixture()
      assert Posts.get_comments!(comments.id) == comments
    end

    test "create_comments/1 with valid data creates a comments" do
      assert {:ok, %Comments{} = comments} = Posts.create_comments(@valid_attrs)
      assert comments.content == "some content"
    end

    test "create_comments/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_comments(@invalid_attrs)
    end

    test "update_comments/2 with valid data updates the comments" do
      comments = comments_fixture()
      assert {:ok, comments} = Posts.update_comments(comments, @update_attrs)
      assert %Comments{} = comments
      assert comments.content == "some updated content"
    end

    test "update_comments/2 with invalid data returns error changeset" do
      comments = comments_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_comments(comments, @invalid_attrs)
      assert comments == Posts.get_comments!(comments.id)
    end

    test "delete_comments/1 deletes the comments" do
      comments = comments_fixture()
      assert {:ok, %Comments{}} = Posts.delete_comments(comments)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_comments!(comments.id) end
    end

    test "change_comments/1 returns a comments changeset" do
      comments = comments_fixture()
      assert %Ecto.Changeset{} = Posts.change_comments(comments)
    end
  end
end
