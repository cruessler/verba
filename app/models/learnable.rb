class Learnable < ActiveRecord::Base
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
  
  def self.random_next
    order('RANDOM()').first
  end
  
  def self.with_bad_rating
    where('rating < 4')
  end
  
  def self.next_with_bad_rating
    with_bad_rating.random_next
  end
  
  def self.scheduled_for_review
    where([ "next_review < ?", Time.now ])
  end
  
  def self.next_scheduled_for_review
    scheduled_for_review.random_next
  end
  
  def self.next_for_review
    next_scheduled_for_review || next_with_bad_rating
  end
end