class BaseLogic
  class InterfaceNotImplemented < StandardError; end

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  # attribute :id, Integer
  # attribute :roleable_type, String
  # attribute :roleable_id, Integer

  def self.create(**args)
    object = self.new(args)
    object.save
    object
  end

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  protected

  def persist!
    raise InterfaceNotImplemented
  end

end