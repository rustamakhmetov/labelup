# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string           default(""), not null
#  name            :string
#  phone           :string
#  password_digest :string
#  token           :string
#  roleable_type   :string
#  roleable_id     :integer
#

class User < ApplicationRecord
  has_secure_token
  has_secure_password

  belongs_to :roleable, polymorphic: true

  validates :name, presence: true
end
