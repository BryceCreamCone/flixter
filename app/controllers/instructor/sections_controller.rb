class Instructor::SectionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user! 
  before_action :require_authorization_for_current_course, only: [:show]
  before_action :require_authorization_for_current_section, only: [:update]

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
  end

  private

  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

  def require_authorization_for_current_course
    if current_course.user != current_user
      return render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def current_section
    @current_section ||= Section.find(params[:id])
  end

  def require_authorization_for_current_section
    if current_section.course.user != current_user
      return render plain: 'Unauthorized', status: :unauthorized
    end
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end
end
