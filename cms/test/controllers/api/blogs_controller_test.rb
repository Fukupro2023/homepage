require "test_helper"

class Api::BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blog = blogs(:one)
    @blog_two = blogs(:two)
    @future_blog = blogs(:future)
  end

  # ===== index =====
  test "index should return published blogs as JSON" do
    get api_blogs_url, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert json.key?("data")
    assert json.key?("meta")

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
    assert_includes ids, @blog_two.id
    assert_not_includes ids, @future_blog.id
  end

  test "index should return correct blog fields" do
    get api_blogs_url, as: :json
    json = JSON.parse(response.body)

    blog_data = json["data"].find { |b| b["id"] == @blog.id }
    assert_equal @blog.title, blog_data["title"]
    assert_equal @blog.description, blog_data["description"]
    assert_equal @blog.content, blog_data["content"]
    assert_equal @blog.author, blog_data["author"]
    assert_includes blog_data["tags"], "Rails"
    assert_includes blog_data["tags"], "Ruby"
  end

  test "index should order by published_at desc" do
    get api_blogs_url, as: :json
    json = JSON.parse(response.body)

    dates = json["data"].map { |b| b["published_at"] }
    assert_equal dates, dates.sort.reverse
  end

  # ===== ページネーション =====
  test "index should paginate with limit and page" do
    get api_blogs_url, params: { limit: 1, page: 1 }, as: :json
    json = JSON.parse(response.body)

    assert_equal 1, json["data"].length
    assert_equal 1, json["meta"]["current_page"]
    assert_equal 1, json["meta"]["limit"]
  end

  test "index should return correct total_pages" do
    get api_blogs_url, params: { limit: 1 }, as: :json
    json = JSON.parse(response.body)

    published_count = Blog.where("published_at <= ?", Time.zone.now).count
    assert_equal published_count, json["meta"]["total_count"]
    assert_equal published_count, json["meta"]["total_pages"]
  end

  test "index should clamp limit to MAX_LIMIT" do
    get api_blogs_url, params: { limit: 999 }, as: :json
    json = JSON.parse(response.body)

    assert_equal 100, json["meta"]["limit"]
  end

  test "index should default page to 1 for invalid page" do
    get api_blogs_url, params: { limit: 10, page: -5 }, as: :json
    json = JSON.parse(response.body)

    assert_equal 1, json["meta"]["current_page"]
  end

  # ===== search =====
  test "search should return all published blogs without query" do
    get search_api_blogs_url, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    ids = json["data"].map { |b| b["id"] }
    assert_not_includes ids, @future_blog.id
  end

  test "search should filter by keyword" do
    get search_api_blogs_url, params: { q: "テスト記事1" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
  end

  test "search should filter by tag: prefix" do
    get search_api_blogs_url, params: { q: "tag:Rails" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
    assert_not_includes ids, @blog_two.id
  end

  test "search should filter by author: prefix" do
    get search_api_blogs_url, params: { q: "author:別の著者" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog_two.id
    assert_not_includes ids, @blog.id
  end

  test "search should support pagination" do
    get search_api_blogs_url, params: { q: "テスト", limit: 1, page: 1 }, as: :json
    json = JSON.parse(response.body)

    assert_equal 1, json["data"].length
    assert_equal 1, json["meta"]["current_page"]
  end

  test "search should not return future blogs" do
    get search_api_blogs_url, params: { q: "未来" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_not_includes ids, @future_blog.id
  end

  # ===== 複合検索 =====
  test "search should filter by tag and keyword combined" do
    get search_api_blogs_url, params: { q: "tag:Rails テスト記事1" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
    assert_not_includes ids, @blog_two.id
  end

  test "search should filter by author and tag combined" do
    get search_api_blogs_url, params: { q: "author:テスト著者 tag:Rails" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
    assert_not_includes ids, @blog_two.id
  end

  test "search should return empty when compound conditions contradict" do
    get search_api_blogs_url, params: { q: "tag:JavaScript author:テスト著者" }, as: :json
    json = JSON.parse(response.body)

    assert_empty json["data"]
  end

  test "search should filter by multiple keywords" do
    get search_api_blogs_url, params: { q: "テスト記事1 テスト本文1" }, as: :json
    json = JSON.parse(response.body)

    ids = json["data"].map { |b| b["id"] }
    assert_includes ids, @blog.id
    assert_not_includes ids, @blog_two.id
  end
end
