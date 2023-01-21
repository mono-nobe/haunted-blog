# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :allowed_for_unloggedin, lambda { |id|
    find_by!('id = ? AND secret = FALSE', id)
  }

  scope :allowed_for_loggedin, lambda { |id, user_id|
    find_by!('id = ? AND (secret = FALSE OR user_id = ?)', id, user_id)
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
