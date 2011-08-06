class Book < ActiveRecord::Base
  acts_as_audited

  def name
    self.title
  end
end
