require "test_helper"

class Api::TagsControllerTest < ActionDispatch::IntegrationTest
  # ===== index =====
  test "index should return tags with counts" do
    get api_tags_url, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert json.key?("tags")
    assert json.key?("count")

    tag_names = json["tags"].map { |t| t["name"] }
    assert_includes tag_names, "Rails"
    assert_includes tag_names, "Ruby"
    assert_includes tag_names, "JavaScript"
  end

  test "index should return correct blog counts per tag" do
    get api_tags_url, as: :json
    json = JSON.parse(response.body)

    rails_tag = json["tags"].find { |t| t["name"] == "Rails" }
    assert_equal 1, rails_tag["count"]

    javascript_tag = json["tags"].find { |t| t["name"] == "JavaScript" }
    assert_equal 1, javascript_tag["count"]
  end

  test "index should order by blog count descending" do
    get api_tags_url, as: :json
    json = JSON.parse(response.body)

    counts = json["tags"].map { |t| t["count"] }
    assert_equal counts, counts.sort.reverse
  end

  test "index count should match number of tags" do
    get api_tags_url, as: :json
    json = JSON.parse(response.body)

    assert_equal json["tags"].length, json["count"]
  end

  test "index should return blog counts matching actual associations" do
    get api_tags_url, as: :json
    json = JSON.parse(response.body)

    json["tags"].each do |tag_data|
      tag = Tag.find_by(name: tag_data["name"])
      assert_equal tag.blogs.count, tag_data["count"],
        "Tag '#{tag_data["name"]}' の記事数が実際の関連数と一致しません"
    end
  end
end
