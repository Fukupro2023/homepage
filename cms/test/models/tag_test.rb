require "test_helper"

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = tags(:rails)
  end

  # ===== バリデーション =====
  test "should be valid with a name" do
    assert @tag.valid?
  end

  test "should require name" do
    @tag.name = nil
    assert_not @tag.valid?
    assert_includes @tag.errors[:name], "can't be blank"
  end

  test "should require unique name" do
    duplicate = Tag.new(name: @tag.name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  # ===== アソシエーション =====
  test "should have many blogs through blog_tags" do
    assert_respond_to @tag, :blogs
    assert_includes @tag.blogs, blogs(:one)
  end

  test "should destroy associated blog_tags when destroyed" do
    assert_difference("BlogTag.count", -@tag.blog_tags.count) do
      @tag.destroy
    end
  end
end
