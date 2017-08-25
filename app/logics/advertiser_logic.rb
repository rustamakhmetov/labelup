class AdvertiserLogic < UserLogic
  attribute :organization, String
  attribute :position, String

  validates :organization, presence: true
  validates :position, presence: true
end