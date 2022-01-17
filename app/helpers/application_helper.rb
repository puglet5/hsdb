# frozen_string_literal: false

module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def auth_helper(tag_type, style = '')
    auth_links = ''

    if user_signed_in?
      auth_links << "<#{tag_type}>#{link_to t('auth.logout'), destroy_user_session_path, method: :delete,
                                                                                         class: style}</#{tag_type}>"
    else
      auth_items.each do |item|
        auth_links << "<#{tag_type}><a href='#{item[:url]}' class = '#{style} #{active? item[:url]}'> #{item[:title]} </a></#{tag_type}>"
      end
    end

    sanitize auth_links.html_safe
  end

  def set_copyright
    # Renderer.copyright "Michael Basmanov", "All rights reserved"
    Renderer.copyright t('footer.itmo')
  end

  def auth_items
    [
      {
        url: new_user_session_path,
        title: t('auth.login')
      },
      {
        url: new_user_registration_path,
        title: t('auth.register')
      }
    ]
  end

  def nav_items
    [
      {
        url: root_path,
        title: t('nav.home')
      },
      {
        url: about_path,
        title: t('nav.about')
      },
      {
        url: uploads_path,
        title: t('nav.uploads')
      },
      {
        url: discussions_path,
        title: t('nav.forum')
      }
    ]
  end

  def nav_helper(tag_type, style = '')
    nav_links = ''

    nav_items.each do |item|
      nav_links << "<#{tag_type} class= '#{active? item[:url]}'><a href='#{item[:url]}' class = '#{style}'> #{item[:title]} </a></#{tag_type}>"
    end

    sanitize nav_links.html_safe
  end

  def active?(path)
    'active' if current_page? path
  end

  # require 'redcarpet/render_strip'

  def has_role?(role)
    current_user&.has_role?(role)
  end

  class Renderer
    def self.copyright(msg)
      # "&copy; #{Time.now.year} | <b>#{name}</b> | #{msg}".html_safe
      "#{Time.zone.now.year} | #{msg}"
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
