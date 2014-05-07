class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :learnable
  
  after_initialize :set_default_values
  
  def recalc_e_factor! rating
    if rating < 3
      self.interval = 1
      self.repetition = 1
    else
      self.interval = next_interval
      self.repetition = repetition + 1
    end
    
    self.next_review = next_review + interval.days
    self.e_factor = e_factor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02))
    self.e_factor = 1.3 if e_factor < 1.3
    self.rating = rating
  end

  def next_interval
    case self.repetition
    when 1 then 1
    when 2 then 6
    else (self.interval * self.e_factor).round
    end
  end
  
  def set_default_values
    self.repetition = 1 unless self.repetition
    self.next_review = Time.now unless self.next_review
    self.e_factor = 2.5 unless self.e_factor
    self.rating = 0 unless self.rating
  end
end
