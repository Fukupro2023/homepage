require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  # ===== markdown =====
  test "markdown should return empty string for nil" do
    assert_equal "", markdown(nil)
  end

  test "markdown should return empty string for blank" do
    assert_equal "", markdown("")
  end

  test "markdown should render bold text" do
    result = markdown("**太字**")
    assert_includes result, "<strong>太字</strong>"
  end

  test "markdown should render links" do
    result = markdown("https://example.com")
    assert_includes result, "<a"
    assert_includes result, "https://example.com"
  end

  test "markdown should render fenced code blocks" do
    result = markdown("```ruby\nputs 'hello'\n```")
    assert_includes result, "<code"
  end

  test "markdown should render tables" do
    md = "| A | B |\n|---|---|\n| 1 | 2 |"
    result = markdown(md)
    assert_includes result, "<table>"
  end

  test "markdown should render strikethrough" do
    result = markdown("~~取り消し線~~")
    assert_includes result, "<del>取り消し線</del>"
  end

  # ===== page_numbers_for =====
  test "page_numbers_for should return all pages when total <= 5" do
    assert_equal [ 1, 2, 3, 4, 5 ], page_numbers_for(3, 5)
  end

  test "page_numbers_for should return all pages when total is 1" do
    assert_equal [ 1 ], page_numbers_for(1, 1)
  end

  test "page_numbers_for should include first and last page" do
    result = page_numbers_for(5, 10)
    assert_equal 1, result.first
    assert_equal 10, result.last
  end

  test "page_numbers_for should include ellipsis for gap at start" do
    result = page_numbers_for(8, 10)
    assert_includes result, :ellipsis
    assert_includes result, 1
    assert_includes result, 10
  end

  test "page_numbers_for should include ellipsis for gap at end" do
    result = page_numbers_for(2, 10)
    assert_includes result, :ellipsis
    assert_includes result, 1
    assert_includes result, 10
  end

  test "page_numbers_for should include current page and neighbors" do
    result = page_numbers_for(5, 10)
    assert_includes result, 4
    assert_includes result, 5
    assert_includes result, 6
  end
end
