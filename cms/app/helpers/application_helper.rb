module ApplicationHelper
  def markdown(text)
    return "" if text.blank?

    renderer = Redcarpet::Render::HTML.new(
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
end
