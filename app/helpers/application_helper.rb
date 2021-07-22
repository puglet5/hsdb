module ApplicationHelper
  def auth_helper(style = "")
    if current_user.is_a?(GuestUser)
      (link_to "Login", new_user_session_path, class: style) +
      (link_to " Register", new_user_registration_path, class: style)
    else
      link_to "Logout", destroy_user_session_path, method: :delete, class: style
    end
  end

  def set_copyright
    ViewTool::Renderer.copyright "Michael Basmanov", "All rights reserved"
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

  def nav_helper(style, tag_type)
    nav_links = ""

    nav_items.each do |item|
      nav_links << "<#{tag_type}><a href='#{item[:url]}' class = '#{style} #{active? item[:url]}'> #{item[:title]} </a></#{tag_type}>"
    end

    nav_links.html_safe
  end

  def active?(path)
    "active" if current_page? path
  end
end

module ViewTool
  class Renderer
    def self.copyright(name, msg)
      "<div> &copy; #{Time.now.year} | <b>#{name}</b> | #{msg} </div>".html_safe
    end
  end
end
