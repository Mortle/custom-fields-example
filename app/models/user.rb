# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :custom_field_values, as: :fieldable, dependent: :destroy

  accepts_nested_attributes_for :custom_field_values, allow_destroy: true
end
