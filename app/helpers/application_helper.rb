module ApplicationHelper
  def auth_helper(style = "", tag_type)
    auth_links = ""

    if current_user.is_a?(GuestUser)
      auth_items.each do |item|
        auth_links << "<#{tag_type}><a href='#{item[:url]}' class = '#{style} #{active? item[:url]}'> #{item[:title]} </a></#{tag_type}>"
      end
    else
      auth_links << "<#{tag_type}>#{link_to "Logout", destroy_user_session_path, method: :delete, class: style}</#{tag_type}>"
    end

    auth_links.html_safe
  end

  def set_copyright
    # Renderer.copyright "Michael Basmanov", "All rights reserved"
    Renderer.copyright "Michael Basmanov", "ITMO University"
  end

  def auth_items
    [
      {
        url: new_user_session_path,
        title: "Login",
      },
      {
        url: new_user_registration_path,
        title: "Register",
      },
    ]
  end

  def nav_items
    [
      {
        url: root_path,
        title: "Home",
      },
      {
        url: about_path,
        title: "About",
      },
      {
        url: uploads_path,
        title: "Uploads",
      },
      {
        url: discussions_path,
        title: "Forum",
      },
    ]
  end

  def nav_helper(style = "", tag_type)
    nav_links = ""

    nav_items.each do |item|
      nav_links << "<#{tag_type} class= '#{active? item[:url]}'><a href='#{item[:url]}' class = '#{style}'> #{item[:title]} </a></#{tag_type}>"
    end

    nav_links.html_safe
  end

  def active?(path)
    "active" if current_page? path
  end

  require "redcarpet/render_strip"

  def has_role?(role)
    current_user && current_user.has_role?(role)
  end

  class Renderer
    def self.copyright(name, msg)
      # "&copy; #{Time.now.year} | <b>#{name}</b> | #{msg}".html_safe
      "#{Time.now.year} | <b>#{name}</b> | #{msg}".html_safe
    end
  end

  # # Markdown Helpers
  # class CodeRayify < Redcarpet::Render::HTML
  #   def block_code(code, language)
  #     CodeRay.scan(code, language).div
  #   end
  # end

  # def markdown(text)
  #   coderayified = CodeRayify.new(:filter_html => true, :hard_wrap => true)
  #   options = {
  #     fenced_code_blocks: true,
  #     no_intra_emphasis: true,
  #     autolink: true,
  #     lax_html_blocks: true,
  #   }
  #   markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
  #   markdown_to_html.render(text).html_safe
  # end

  # def strip_markdown(string)
  #   markdown_to_plain_text = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
  #   markdown_to_plain_text.render(string).html_safe
  # end
end
