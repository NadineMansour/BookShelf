class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline , :class_name => 'User'
  has_many :comments ,dependent: :destroy

	validates :book, presence: true
	validates :author, presence: true
	validates :content, presence: true
	
end
