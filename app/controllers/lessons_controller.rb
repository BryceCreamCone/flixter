class LessonsController < ApplicationController
  before_action :authenticate_user!

  def show
    unless authorized
      redirect_to course_path(current_course),
      alert: 'You have not purchased this course'
    end
  end

  private

  helper_method :current_lesson, :current_course
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  def current_course
    current_section ||= Section.find_by(id: current_lesson.section_id)
    @current_course ||= Course.find_by(id: current_section.course_id)
  end

  def authorized
    current_user.enrolled_in?(current_course) or (current_user.id == current_course.user_id)
  end
  
end
