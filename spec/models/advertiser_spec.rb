require 'rails_helper'

RSpec.describe Advertiser, type: :model do
  it { should have_one(:user) }
end
