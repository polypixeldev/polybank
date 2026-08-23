module MarkdownHelper
  def render_markdown(content)
    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      no_links: false,
      no_images: false,
      safe_links_only: true,
      escape_html: false
    )

    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      strikethrough: true,
      superscript: true,
      tables: true
    )

    sanitize(markdown.render(content))
  end
end
