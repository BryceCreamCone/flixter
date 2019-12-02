class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
# add_flash_types :success, :warning

  def create
    begin
      token = params[:stripeToken]

      charge = Stripe::Charge.create({
        amount: dollars_to_cents(current_course.cost),
        currency: 'usd',
        description: 'Example charge',
        source: token,
      })
      current_user.enrollments.create(course: current_course)
    rescue Stripe::CardError => e
      body = e.json_body
      @err  = body[:error]
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    rescue => e
      # Something else happened, completely unrelated to Stripe
    end
    if @err
      flash[:error] = "#{@err[:message] + " - " + @err[:decline_code]}"
    else
      flash[:success] = "Thank you for your Purchase! Enjoy!"
    end
    redirect_to course_path(current_course)
  end

  private

  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

  def dollars_to_cents(cost)
    (cost*100).to_i
  end
end
