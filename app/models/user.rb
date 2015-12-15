class User < ActiveRecord::Base
	require 'fb_graph2'
	has_many :friendships ,dependent: :destroy
	has_many :friends, through: :friendships ,dependent: :destroy
	has_many :posts  ,dependent: :destroy
	has_many :comments  ,dependent: :destroy

	before_create -> { self.token = SecureRandom.hex }, unless: :token?

	#Virtual attribute
	def full_name
		[first_name , last_name].join(' ')
	end
	
	#methods
  	def self.search(query)
    	where("name like ?", "%#{query}%") 
  	end

  	def self.authenticate(fbtoken)

  		user = FbGraph2::User.me(fbtoken).fetch(fields: [:name,:email, :first_name, :last_name, :id , :picture])
  		uid = user.identifier
  		name = user.name
  		first = user.first_name
  		last = user.last_name
  		email = user.email
  		picture = user.picture.url
  		my_user = find_by(uid: uid)
  		if my_user.present?
  			my_user
  		else
  			create(
  				provider: "facebook",
				uid: uid,
				name: name,
				email: email,
				picture: picture
				#first_name: first
				#last_name: last
  			)
  			find_by(uid: uid)
  		end
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
