module WickedPdfHelper
  def wicked_pdf_stylesheet_link_tag(*sources)
    css_dir = WickedPdf::WickedPdfHelper.root_path.join('public', 'stylesheets')
    css_text = sources.collect do |source|
      source = WickedPdf::WickedPdfHelper.add_extension(source, 'css')
      "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    end.join("\n")
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end

  def plugin_wicked_pdf_stylesheet_link_tag(*sources, plugin: 'human_resources')
    css_dir = WickedPdf::WickedPdfHelper.root_path.join("public/plugin_assets/#{plugin}", 'stylesheets')
    css_text = sources.collect do |source|
      source = WickedPdf::WickedPdfHelper.add_extension(source, 'css')
      "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    end.join("\n")
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end

  def plugin_wicked_pdf_image_tag(img, options = {})
    image_tag "file:///#{WickedPdf::WickedPdfHelper.root_path
                             .join("public/plugin_assets/#{options[:plugin]}", 'images', img)}",
              options.except(:plugin)
  end

  def plugin_wicked_pdf_javascript_src_tag(jsfile, plugin = 'human_resources', options: {})
    jsfile = WickedPdf::WickedPdfHelper.add_extension(jsfile, 'js')
    src = "file:///#{WickedPdf::WickedPdfHelper.root_path
                         .join("public/plugin_assets/#{plugin}", 'javascripts', jsfile)}"
    content_tag('script', '', {'type' => Mime::JS, 'src' => path_to_javascript(src)}.merge(options))
  end

  def plugin_wicked_pdf_javascript_include_tag(*sources, plugin: 'human_resources')
    js_text = sources.collect {|source| plugin_wicked_pdf_javascript_src_tag(source, plugin, {})}.join("\n")
    js_text.respond_to?(:html_safe) ? js_text.html_safe : js_text
  end

  def custom_plugin_wicked_pdf_stylesheet_link_tag(*sources, plugin: 'human_resources', directory: '')
    css_dir = WickedPdf::WickedPdfHelper.root_path.join("public/plugin_assets/#{plugin}/#{directory}", 'css')
    css_text = sources.collect {|source|
      source = WickedPdf::WickedPdfHelper.add_extension(source, 'css')
      "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    }.join("\n")
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end
end
