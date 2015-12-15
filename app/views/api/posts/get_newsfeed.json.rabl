collection @newsfeed , object_root: false
attributes :id, :book, :content, :genre , :author, :user_id, :timeline_id

child :user do
	attributes :name
end

child timeline: :timeline do
	attributes :name
end
