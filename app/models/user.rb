class User < ActiveRecord::Base
	has_many :friendships ,dependent: :destroy
	has_many :friends, through: :friendships ,dependent: :destroy
	has_many :posts  ,dependent: :destroy
	has_many :comments  ,dependent: :destroy

	#Virtual attribute
	def full_name
		[first_name , last_name].join(' ')
	end
	
	#methods
  	def self.search(query)
    	where("name like ?", "%#{query}%") 
  	end

	def self.sign_in_from_omniauth(auth)
		user = find_by(provider: auth['provider'], uid: auth['uid'])

		if user.nil?
		  user = create_user_from_omniauth(auth)
		end

		user
	end

	def self.create_user_from_omniauth(auth)
		create(
			provider: auth['provider'],
			uid: auth['uid'],
			name: auth['info']['name'],
			email: auth['info']['email'],
			picture: auth['info']['image']
		)
	end
end
