Rails.application.config.middleware.use OmniAuth::Builder do 
	provider :facebook, '1518672208448051' , '1cdd09c3d263a6bb30a6d33e2ec05701'
	provider :twitter, '2hn9aYyTf8lpE9nBXkDuRfsxP' , 'KVIMEyLu2awUFYY7STsNG8CUJmkgbubTqZDrj3JOikmNL5NTWm'
end