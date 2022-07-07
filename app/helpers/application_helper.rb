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

  def auth_helper(tag_type, style = '', _active_class)
    auth_links = ''

    if user_signed_in?
      auth_links << "<#{tag_type}>#{link_to 'Profile page', "/#{locale}/users/#{current_user.slug}", class: style.to_s}</#{tag_type}>"

      auth_links << "<#{tag_type}>#{link_to t('auth.logout'), destroy_user_session_path, turbo_method: :delete, class: style}</#{tag_type}>"

    else
      auth_items.each do |item|
        auth_links << "<#{tag_type}><a href='#{item[:url]}' class = '#{style}'> #{item[:title]} </a></#{tag_type}>"
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
        controller: Rails.application.routes.recognize_path(root_path)[:controller],
        title: t('nav.home'),
        icon: '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>'
      },
      {
        url: about_path,
        controller: Rails.application.routes.recognize_path(about_path)[:controller],
        title: t('nav.about'),
        icon: '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>'
      },
      {
        url: uploads_path,
        controller: Rails.application.routes.recognize_path(uploads_path)[:controller],
        title: t('nav.uploads'),
        icon: '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>'
      },
      {
        url: discussions_path,
        controller: Rails.application.routes.recognize_path(discussions_path)[:controller],
        title: t('nav.forum'),
        icon: '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>'
      }
    ]
  end

  def nav_helper(tag_type, style = '', active_class = '', icons = false)
    nav_links = ''

    if icons == true
      nav_items.each do |item|
        nav_links << "<#{tag_type} class= '#{active? item[:controller], item[:url], active_class}'><a href='#{item[:url]}' class = '#{style} #{active? item[:controller], item[:url], active_class}'> #{item[:icon]} </a></#{tag_type}>"
      end
    else

      nav_items.each do |item|
        nav_links << "<#{tag_type} class= '#{active? item[:controller], item[:url], active_class}'><a href='#{item[:url]}' class = '#{style} #{active? item[:controller], item[:url], active_class}'> #{item[:title]} </a></#{tag_type}>"
      end

    end
    nav_links.html_safe
  end

  def active?(controller, url, klass)
    klass.to_s if (params[:controller] == controller && !params[:action].in?(%w[home about])) || (params[:action].in?(%w[home about]) && current_page?(url))
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
