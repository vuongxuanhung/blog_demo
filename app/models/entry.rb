class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  default_scope -> {order(created_at: :desc)}

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 200 }
  validates :content, presence: true, length: { maximum: 500 }
  # validate :picture_size

  private
  # def picture_size
		# if picture.size > 5.megabytes
		# 	errors.add(:picture, "should be less than 5MB")
		# end
  # end
end
