module ApplicationHelper
  include RailsCharts::Helpers
  include Chartkick::Helper

  def title(text)
    content_for :title, "#{text} | Polybank"
  end

  def inline_icon(filename, **options)
    # cache parsed SVG files to reduce file I/O operations
    @icon_svg_cache ||= {}
    if !@icon_svg_cache.key?(filename)
      file = File.read(Rails.root.join("app", "assets", "images", "icons", "#{filename}.svg"))
      @icon_svg_cache[filename] = Nokogiri::HTML::DocumentFragment.parse file
    end

    doc = @icon_svg_cache[filename].dup
    svg = doc.at_css "svg"
    options[:style] ||= ""
    if options[:size]
      options[:width] ||= options[:size]
      options[:height] ||= options[:size]
      options.delete :size
    end
    unless options["aria-label"]
      options["aria-hidden"] = true
    end
    options.each { |key, value| svg[key.to_s] = value }
    doc.to_html.html_safe
  end

  %i[pie_chart line_chart].each do |method_name|
    define_method(method_name) do |*args, **kwargs, &block|
      Chartkick::Helper.instance_method(method_name).bind(self).call(*args, **kwargs, &block)
    end
  end
end
