class Recipe < ApplicationRecord
  before_create :default_values

  private
    def default_values()
      self.priority ||= 0
      self.quantity ||= 1.0
      self.machine = "crafting" if !self.machine || self.machine == ""
      self.image ||= self.name if self.name
    end
end
