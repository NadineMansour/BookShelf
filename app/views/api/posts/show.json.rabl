collection @post
attributes :id , :genre , :book , :author , :content , :user_id , :timeline_id
child(:comments) { attributes :user_id , :content}