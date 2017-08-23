class UserLogic < BaseLogic
  attribute :password, String
  attribute :name, String
  attribute :email, String
  attribute :phone, String

  validates :password, presence: true
  validates :name, presence: true
  validates :email, presence: true

  protected

  def persist!
    raise InterfaceNotImplemented
  end
end
