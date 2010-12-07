class Feedback < ActiveRecord::Base
  validates :text, :presence   => true  
  default_scope :order => 'created_at DESC'
  
  def send_to_developer
    Mailer.send_to_developer(self.text,self.email).deliver if self.save
  end
end
