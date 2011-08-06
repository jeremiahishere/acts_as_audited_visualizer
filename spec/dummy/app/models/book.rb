class Book < ActiveRecord::Base

  def name
    self.title
  end
end
