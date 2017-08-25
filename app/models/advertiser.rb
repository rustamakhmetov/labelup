# == Schema Information
#
# Table name: advertisers
#
#  id           :integer          not null, primary key
#  organization :string
#  position     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Advertiser < ApplicationRecord
  has_one :user, as: :roleable
end
