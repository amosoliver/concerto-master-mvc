module Uppercasable
  extend ActiveSupport::Concern

  class_methods do
    def upcases(*attributes)
      before_validation do
        attributes.each do |attribute|
          value = self[attribute]
          self[attribute] = value.upcase if value.is_a?(String)
        end
      end
    end
  end
end
