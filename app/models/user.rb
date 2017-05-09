class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 enum user_context: { owner: 0, admin: 1 }
 enum approved_status: { status_unapproved: 0, status_approved: 1 }

 scope :approved, -> { where(approved_status: :status_approved) }
 scope :unapproved, -> { where(approved_status: :status_unapproved) }
 scope :owner, -> { where(user_context: :owner) }

 has_many :events
 validates :name, presence: true

 def self.owners
   self.where(user_context: "owner")
 end

 def self.admins
   self.where(user_context: "admin")
 end

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

 def can_view_owner?(owner)
   if admin? || self == owner
     true
   else
     false
   end
 end
end
