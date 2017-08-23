class AdvertiserLogic < UserLogic
  attribute :organization, String
  attribute :position, String

  validates :organization, presence: true
  validates :position, presence: true

  def persisted?
    !!(@user.try(:persisted?) && @advertiser.try(:persisted?))
  end

  protected

  def persist!
    User.transaction do
      @advertiser = Advertiser.create(self.attributes.slice(:organization, :position))
      @user = User.create(self.attributes.slice(:name, :phone, :email, :password).merge(roleable: @advertiser))
    end
  end
end