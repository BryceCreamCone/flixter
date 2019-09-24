class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorization_for_current_course, only: [:show]
                

  def new 
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    if @course.valid?
      redirect_to instructor_course_path(@course)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    current_course.update_attributes(course_params)
  end

  def show
    @section = Section.new
    @lesson = Lesson.new
  end

  private

  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:id])
  end

  def current_section 
    @current_section ||= Section.find(params[:course_id])
  end

  def require_authorization_for_current_course
    if current_course.user != current_user
      return render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def course_params
    params.require(:course).permit(:title, :description, :cost, :image)
  end
end
