class BaseLogic
  class InterfaceNotImplemented < StandardError; end

  include Virtus.model

  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

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