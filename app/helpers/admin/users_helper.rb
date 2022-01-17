# frozen_string_literal: true

module Admin
  module UsersHelper
    def user_roles
      Role.all.map do |role|
        [role.name, role.id]
      end
    end
  end
end
