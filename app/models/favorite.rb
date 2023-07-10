# frozen_string_literal: true

# == Schema Information
#
# Table name: favorites
#
#  blocked          :boolean          default(FALSE), not null, indexed
#  created_at       :datetime         not null
#  favoritable_id   :bigint           not null, indexed => [favoritable_type], indexed => [favoritable_type], indexed => [favoritable_type, favoritor_type, favoritor_id, scope]
#  favoritable_type :string           not null, indexed => [favoritable_id], indexed => [favoritable_id], indexed => [favoritable_id, favoritor_type, favoritor_id, scope]
#  favoritor_id     :bigint           not null, indexed => [favoritor_type], indexed => [favoritor_type], indexed => [favoritable_type, favoritable_id, favoritor_type, scope]
#  favoritor_type   :string           not null, indexed => [favoritor_id], indexed => [favoritor_id], indexed => [favoritable_type, favoritable_id, favoritor_id, scope]
#  id               :bigint           not null, primary key
#  scope            :string           default("favorite"), not null, indexed, indexed => [favoritable_type, favoritable_id, favoritor_type, favoritor_id]
#  updated_at       :datetime         not null
#
# Indexes
#
#  fk_favoritables                   (favoritable_id,favoritable_type)
#  fk_favorites                      (favoritor_id,favoritor_type)
#  index_favorites_on_blocked        (blocked)
#  index_favorites_on_favoritable    (favoritable_type,favoritable_id)
#  index_favorites_on_favoritor      (favoritor_type,favoritor_id)
#  index_favorites_on_scope          (scope)
#  uniq_favorites__and_favoritables  (favoritable_type,favoritable_id,favoritor_type,favoritor_id,scope) UNIQUE
#
class Favorite < ApplicationRecord
  extend ActsAsFavoritor::FavoriteScopes

  belongs_to :favoritable, polymorphic: true
  belongs_to :favoritor, polymorphic: true

  def block!
    update!(blocked: true)
  end
end
