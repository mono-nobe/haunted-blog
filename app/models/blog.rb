# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :owned, lambda { |user_id|
    where('user_id = ?', user_id)
  }

  scope :allowed, lambda { |user_id|
    published.or(owned(user_id))
  }

  scope :search, lambda { |term|
    term = '' if term.blank?
    where('title LIKE ?', "%#{sanitize_sql_like(term)}%")
      .or(Blog.where('content LIKE ?', "%#{sanitize_sql_like(term)}%"))
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
