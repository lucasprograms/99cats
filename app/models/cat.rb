class Cat < ApplicationRecord
  CAT_COLORS = ['brown', 'green', 'orange', 'tabby', 'white', 'black']
  validates :name, :birth_date, presence: true
  validates :color, presence: true, inclusion: { in: CAT_COLORS }
  validates :sex, presence: true, inclusion: { in: ['M', 'F'] }

  has_many :cat_rental_requests, dependent: :destroy

  def age
    dob = self.birth_date
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
