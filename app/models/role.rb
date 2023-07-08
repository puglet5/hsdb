# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  created_at    :datetime         not null
#  id            :bigint           not null, primary key
#  name          :string           indexed => [resource_type, resource_id]
#  resource_id   :bigint           indexed => [name, resource_type], indexed => [resource_type]
#  resource_type :string           indexed => [name, resource_id], indexed => [resource_id]
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource                                (resource_type,resource_id)
#
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
