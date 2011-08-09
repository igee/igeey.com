class Feedback < ActiveRecord::Base
  validates :text, :presence   => true  
  default_scope :order => 'created_at DESC'
  
  def send_new_feedback
    Mailer.send_new_feedback(self).deliver if self.save
  end

end
