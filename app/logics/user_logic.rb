class UserLogic < BaseLogic
  attribute :name, String
  attribute :email, String
  attribute :phone, String
  attribute :password, String

  attr_reader :user_role

  validates_each :password, presence: true do |record, attr, value|
    record.errors.add attr, "can't be blank" if record.user.nil? && value.nil?
  end
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
    object = User.find_by_id(id)
    raise Errors::UnprocessableEntity, "User not exists" unless object

    roleable = object.roleable
    klass = make_klass(roleable)
    user = klass.new(object.attributes.merge(roleable.attributes))
    user.user = object
    user
  end

  def user=(value)
    @user = value
    @user_role = @user.roleable if @user
    integrity!
  end

  def user
    @user
  end

  def reload
    if @user
      @user.reload
      @user_role.reload
      self.attributes = @user.attributes.merge(@user_role.attributes)
    end
  end

  def persisted?
    !!(@user.try(:persisted?) && @user_role.try(:persisted?))
  end

  def save
    raise InterfaceNotImplemented if self.class == UserLogic
    super
  end

  def update(params)
    self.attributes = params
    self.save
  end

  def destroy
    User.transaction do
      @user.destroy!
      @user_role.destroy!
    end
  rescue ActiveRecord::RecordNotDestroyed
    raise Errors::InternalServerError
  end

  def integrity!
    raise Errors::UnprocessableEntity, "Violation of integrity" if @user.nil? ^ @user_role.nil?
  end

  def to_json(options = nil)
   self.attributes.compact.to_json(options)
  end

  protected

  def persist!
    User.transaction do
      if @user
        @user.update(attributes_by(self.class.superclass))
        @user_role.update(attributes_by(self.class))
      else
        @user_role = Advertiser.create(attributes_by(self.class))
        @user = User.create(attributes_by(self.class.superclass).merge(roleable: @user_role))
      end
    end
  end

  private

  def attributes_by(klass)
    self.attributes.slice(*klass.attributes).compact
  end
end
