class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 enum user_context: { owner: 0, admin: 1 }

 has_many :events
 validates :name, presence: true

 def owner?
   if user_context == "owner" then return true else return false end
 end

 def admin?
   if user_context == "admin" then return true else return false end
 end

 def owner_or_admin?
   if owner? || admin?
     return true
   else
     return false
   end
 end
end
