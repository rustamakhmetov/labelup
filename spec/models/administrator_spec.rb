require 'rails_helper'

RSpec.describe Administrator, type: :model do
  it { should have_one(:user) }
end
