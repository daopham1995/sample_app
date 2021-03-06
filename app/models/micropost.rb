class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_by_time, -> {order created_at: :desc}
  scope :feeds_list, -> user_id {where user_id: user_id}

  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size
  
  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
