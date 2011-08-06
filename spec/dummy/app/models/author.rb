class Author < ActiveRecord::Base
  acts_as_audited

  def name
    self.first_name + " " + self.last_name
  end
end
