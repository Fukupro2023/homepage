require "test_helper"

class BlogTagTest < ActiveSupport::TestCase
  setup do
    @blog_tag = blog_tags(:one_rails)
  end

  test "should be valid" do
    assert @blog_tag.valid?
  end

  test "should belong to blog" do
    assert_equal blogs(:one), @blog_tag.blog
  end

  test "should belong to tag" do
    assert_equal tags(:rails), @blog_tag.tag
  end

  test "should enforce unique blog-tag combination" do
    duplicate = BlogTag.new(blog: blogs(:one), tag: tags(:rails))
    assert_raises(ActiveRecord::RecordNotUnique) do
      duplicate.save(validate: false)
    end
  end
end
