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
    elsif (params[:controller] == controller && !params[:action].in?(%w[home])) || (params[:action].in?(%w[home]) && current_page?(url))
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

  def display_metadata_value(object)
    JSON.is_json?(object.metadata) && !object.errors.count.positive? ? JSON.generate(object.metadata) : object.metadata
  end

  class Renderer
    def self.copyright(msg)
      "#{Time.zone.now.year} | #{msg}"
    end
  end

  def self.humanize_file_format(str)
    return str.humanize if %w[other not_set].include? str

    ".#{str}"
  end

  def self.humanize_range(str)
    return str.humanize if %w[other not_set].include? str

    str.upcase
  end
end
