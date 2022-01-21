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

  def auth_helper(tag_type, style = '', active_class)
    auth_links = ''

    if user_signed_in?

      auth_links << "<#{tag_type}>#{link_to t('auth.logout'), destroy_user_session_path, method: :delete, class: style}</#{tag_type}>"

      auth_links << "<#{tag_type}>#{link_to current_user.first_name.to_s, "/#{locale}/users/#{current_user.slug}", class: "#{style} #{active? user_path(current_user), active_class}"}</#{tag_type}>"

    else
      auth_items.each do |item|
        auth_links << "<#{tag_type}><a href='#{item[:url]}' class = '#{style} #{active? item[:url], active_class}'> #{item[:title]} </a></#{tag_type}>"
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
        title: t('nav.home'),
        icon: 'home'
      },
      {
        url: about_path,
        title: t('nav.about'),
        icon: 'about'
      },
      {
        url: uploads_path,
        title: t('nav.uploads'),
        icon: 'download'
      },
      {
        url: discussions_path,
        title: t('nav.forum'),
        icon: 'forum'
      }
    ]
  end

  def nav_helper(tag_type, style = '', active_class)
    nav_links = ''

    nav_items.each do |item|
      nav_links << "<#{tag_type} class= '#{active? item[:url], active_class}'><a href='#{item[:url]}' class = '#{style} #{active? item[:url], active_class}'> #{item[:title]} </a></#{tag_type}>"
    end

    sanitize nav_links.html_safe
  end

  def active?(path, klass)
    klass.to_s if current_page? path
  end

  def has_role?(role)
    current_user&.has_role?(role)
  end

  class Renderer
    def self.copyright(msg)
      # "&copy; #{Time.now.year} | <b>#{name}</b> | #{msg}".html_safe
      "#{Time.zone.now.year} | #{msg}"
    end
  end
end
