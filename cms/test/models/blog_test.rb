require "test_helper"

class BlogTest < ActiveSupport::TestCase
  setup do
    @blog = blogs(:one)
    @blog_two = blogs(:two)
    @future_blog = blogs(:future)
  end

  # ===== バリデーション =====
  test "should be valid with all required attributes" do
    assert @blog.valid?
  end

  test "should require title" do
    @blog.title = nil
    assert_not @blog.valid?
    assert_includes @blog.errors[:title], "can't be blank"
  end

  test "should require content" do
    @blog.content = nil
    assert_not @blog.valid?
    assert_includes @blog.errors[:content], "can't be blank"
  end

  test "should require author" do
    @blog.author = nil
    assert_not @blog.valid?
    assert_includes @blog.errors[:author], "can't be blank"
  end

  test "should require description" do
    @blog.description = nil
    assert_not @blog.valid?
    assert_includes @blog.errors[:description], "can't be blank"
  end

  # ===== アソシエーション =====
  test "should have many tags through blog_tags" do
    assert_respond_to @blog, :tags
    assert_includes @blog.tags, tags(:rails)
    assert_includes @blog.tags, tags(:ruby)
  end

  test "should destroy associated blog_tags when destroyed" do
    assert_difference("BlogTag.count", -@blog.blog_tags.count) do
      @blog.destroy
    end
  end

  # ===== search_by_keyword =====
  test "search_by_keyword should find by title" do
    results = Blog.search_by_keyword("テスト記事1")
    assert_includes results, @blog
  end

  test "search_by_keyword should find by content" do
    results = Blog.search_by_keyword("Railsについて")
    assert_includes results, @blog_two
  end

  test "search_by_keyword should find by author" do
    results = Blog.search_by_keyword("別の著者")
    assert_includes results, @blog_two
    assert_not_includes results, @blog
  end

  test "search_by_keyword should find by tag name" do
    results = Blog.search_by_keyword("Rails")
    assert_includes results, @blog
  end

  test "search_by_keyword should find by description" do
    results = Blog.search_by_keyword("テスト概要2")
    assert_includes results, @blog_two
  end

  test "search_by_keyword should return empty for non-matching term" do
    results = Blog.search_by_keyword("存在しないキーワード12345")
    assert_empty results
  end

  # ===== search_by_tag =====
  test "search_by_tag should find blogs with matching tag" do
    results = Blog.search_by_tag("Rails")
    assert_includes results, @blog
    assert_not_includes results, @blog_two
  end

  test "search_by_tag should return empty for non-existing tag" do
    results = Blog.search_by_tag("NonExistentTag")
    assert_empty results
  end

  # ===== search_by_author =====
  test "search_by_author should find blogs by author" do
    results = Blog.search_by_author("テスト著者")
    assert_includes results, @blog
    assert_not_includes results, @blog_two
  end

  test "search_by_author should support partial match" do
    results = Blog.search_by_author("別の")
    assert_includes results, @blog_two
  end

  # ===== header_image_url / content_images_urls =====
  test "header_image_url should return nil when no image attached" do
    assert_nil @blog.header_image_url
  end

  test "content_images_urls should return empty array when no images attached" do
    assert_equal [], @blog.content_images_urls
  end
end
