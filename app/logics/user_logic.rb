class UserLogic < BaseLogic
  attribute :name, String
  attribute :email, String
  attribute :phone, String
  attribute :password, String

  # attribute :password_digest, String
  # attribute :token, String

  attr_accessor :user

  validates :password, presence: true
  validates :name, presence: true
  validates :email, presence: true

  ALLOW_KINDS = [:advertiser]

  def method_missing(method, *args, &block)
    if [:id, :created_at].include?(method)
      return nil unless @user
      @user.__send__(method, *args, &block)
    else
      super(method, *args, &block)
    end
  end

  def self.create(params:)
    klass = params.has_key?(:kind) ? make_klass(params[:kind]) : self
    object = klass.new(params)
    object.save
    object
  end

  def self.find(id)
    object = User.find(id)
    if object
      roleable = object.roleable
      klass = make_klass(roleable)
      user = klass.new(object.attributes.merge(roleable.attributes))
      user.user = object
      user
    end
  end

  def to_json(options = nil)
   self.attributes.compact.to_json(options)
  end

  protected

  def persist!
    raise InterfaceNotImplemented
  end
end
