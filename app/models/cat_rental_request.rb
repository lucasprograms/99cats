class CatRentalRequest < ApplicationRecord
  STATUSES = ['PENDING', 'DENIED', 'APPROVED']
  validates :cat_id, presence: true
  validates :start_date, :end_date, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :does_not_overlap_approved_request

  belongs_to :cat

  def overlapping_requests
    CatRentalRequest
      .where(cat_id: cat_id)
      .where("(start_date BETWEEN ? AND ?) OR (end_date BETWEEN ? AND ?)", start_date, end_date, start_date, end_date)
      .where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end

  def does_not_overlap_approved_request
    if overlapping_approved_requests.exists?
      errors.add(:date_range, 'cannot overlap with an approved request')
    end
  end

  def approve!
    CatRentalRequest.transaction do
      CatRentalRequest.find(self.id).update!(status: 'APPROVED')
      overlapping_pending_requests.update_all(status: 'DENIED')
    end
  end

  def deny!
    CatRentalRequest.find(self.id).update!(status: 'DENIED')
  end

  def pending?
    status == 'PENDING'
  end
end
