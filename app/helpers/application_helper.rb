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

  def original_or_variant(image, variant)
    if variant.key
      variant.processed.url if image.service.exist?(variant.key)
    else
      image.url
    end
  end

  class Renderer
    def self.copyright(msg)
      "#{Time.zone.now.year} | #{msg}"
    end
  end
end
