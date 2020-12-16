class ReviewsController < ApplicationController
  before_action :set_doctor

  def create
    @review = @doctor.reviews.build(review_params)

    respond_to do |format|
      if @review.save

        # doctor save average rating
        total_reviews = @doctor&.reviews ? @doctor&.reviews&.count : 0
        review_sum = @doctor&.reviews ? @doctor&.reviews&.sum(:rating) : 0
        @doctor.avg_rating = review_sum / total_reviews
        @doctor.save(validate: false)

        format.html do
          render(partial: "doctors/thankyou", locals: { object: @review }, status: :ok)
        end
      else
        format.html do
          render(json: { messages: @review.errors.messages }, status: :bad_request)
        end
      end
    end
  end

  private

  def set_doctor
    @doctor = Doctor.find_by_fdd_id(params[:doctor_id])
  end

  def review_params
    params.require(:review).permit(:rating, :title, :name, :email, :review, :treated_by_doctor,
      :will_you_recommend, :anonymous, :status)
  end
end