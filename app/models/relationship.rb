class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # rails5から以下presenceのバリデーションは自動的にチェックされる(なくても動く)
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
