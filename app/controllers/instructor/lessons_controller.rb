class Instructor::LessonsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :require_authorization_for_current_section, only: [:new, :create]
  before_action :require_authorization_for_current_lesson,  only: [:update]
  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = current_section.lessons.create(lesson_params)
    redirect_to instructor_course_path(current_section.course_id)
  end

  def update
    current_lesson.update_attributes(lesson_params)
  end

  private

  helper_method :current_section

  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  def require_authorization_for_current_lesson
    if current_lesson.section.course.user != current_user
      return render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def current_section
    @current_section ||= Section.find(params[:section_id])
  end

  def require_authorization_for_current_section
    if current_section.course.user != current_user
      return render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def lesson_params
    params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
  end

end
