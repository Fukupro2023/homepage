module ApplicationHelper
  # リンクを新しいタブで開くカスタムレンダラー
  class ExternalLinkRenderer < Redcarpet::Render::HTML
    def link(link, title, content)
      title_attr = title ? %( title="#{title}") : ""
      %(<a href="#{link}"#{title_attr} target="_blank" rel="noopener noreferrer">#{content}</a>)
    end

    def autolink(link, link_type)
      %(<a href="#{link}" target="_blank" rel="noopener noreferrer">#{link}</a>)
    end
  end

  def markdown(text)
    return "" if text.blank?

    renderer = ExternalLinkRenderer.new(
      hard_wrap: true,
      filter_html: false
    )
    md = Redcarpet::Markdown.new(renderer,
      autolink: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      no_intra_emphasis: true)
    md.render(text).html_safe # rubocop:disable Rails/OutputSafety
  end

  # ページ番号の配列を生成（省略記号付き）
  def page_numbers_for(current, total)
    return (1..total).to_a if total <= 5

    pages = []
    pages << 1

    start = [ current - 1, 2 ].max
    finish = [ current + 1, total - 1 ].min

    pages << :ellipsis if start > 2
    (start..finish).each { |p| pages << p }
    pages << :ellipsis if finish < total - 1

    pages << total
    pages
  end
end
