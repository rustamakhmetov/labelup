# == Schema Information
#
# Table name: administrators
#
#  id         :integer          not null, primary key
#  admin      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Administrator < ApplicationRecord
  has_one :user, as: :roleable
end
