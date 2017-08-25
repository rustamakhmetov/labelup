class BaseLogic
  class InterfaceNotImplemented < StandardError; end

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def self.make_klass(name)
    name = name.to_s if name.is_a?(Symbol)
    name = name.is_a?(String) ? name : name.class.name
    klass = "#{name.capitalize}Logic".constantize
  end

  def self.create
    raise InterfaceNotImplemented
  end

  def self.attributes
    self.attribute_set.instance_variable_get(:@attributes).map(&:name)
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

  def to_kind
    raise InterfaceNotImplemented
  end

  protected

  def persist!
    raise InterfaceNotImplemented
  end

end