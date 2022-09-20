# frozen_string_literal: false

module ApplicationHelper
  include Pagy::Frontend

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def set_copyright
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

  def get_controller(url)
    Rails.application.routes.recognize_path(url)[:controller]
  end

  def active?(controller, url, klass)
    if params[:controller] == 'categories'
      klass.to_s if controller == 'discussions'
    elsif (params[:controller] == controller && !params[:action].in?(%w[home about])) || (params[:action].in?(%w[home about]) && current_page?(url))
      klass.to_s
    end
  end

  def active_style(url, klass)
    active? get_controller(url), url, klass
  end

  def status_badge_style(status)
    case status
    when 'draft'
      'bg-yellow-100 text-yellow-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded  '
    when 'active'
      'bg-green-100 text-green-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded  '
    when 'archived'
      'bg-gray-100 text-gray-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded  '
    else
      'bg-primary-100 text-primary-800 text-sm font-medium mr-2 px-2.5 py-0.5 rounded  '
    end
  end

  def status_badge_color(status)
    case status
    when 'draft'
      'text-yellow-300'
    when 'active'
      'text-green-300'
    when 'archived'
      'text-gray-300'
    else
      'text-primary-300'
    end
  end

  class Renderer
    def self.copyright(msg)
      "#{Time.zone.now.year} | #{msg}"
    end
  end
end
