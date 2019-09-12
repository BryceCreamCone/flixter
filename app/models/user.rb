class User < ApplicationRecord
  has_many :courses
  has_many :enrollments
  has_many :enrolled_courses, through: :enrollments, source: :course
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  def enrolled_in?(course)
    return enrolled_courses.include?(course)
  end

  protected
  def confirmation_required? 
    false 
  end
end
