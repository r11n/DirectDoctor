module Admin
  class DoctorsController < Admin::BaseController
    before_action :set_doctor, only: [:show, :edit, :update]
    before_action :set_master_data, only: [:edit, :new]

    def index
      @q = Doctor.ransack(params[:q])
      @doctors = @q.result.latest

      @pagy, @doctors = pagy(@doctors)
    end

    def show
    end

    def new
      @doctor = Doctor.new(
        min_experience: Doctor.default_experience&.first,
        max_experience: Doctor.default_experience&.last,
        min_patients: Doctor.default_patient&.first,
        max_patients: Doctor.default_patient&.last,
        min_price: Doctor.default_price&.first,
        max_price: Doctor.default_price&.last,
      )
    end

    def edit
    end

    def create
      @doctor = Doctor.new(doctor_params)
      respond_to do |format|
        if @doctor.save
          format.html { redirect_to admin_doctors_url, notice: 'Doctor was successfully created.' }
          format.json { render :show, status: :created, location: @doctor }
        else
          format.html { render(partial: "shared/partials/errors", locals: { object: @doctor }, status: :bad_request) }
        end
      end
    end

    def update
      respond_to do |format|
        if @doctor.update(doctor_params)
          format.html { redirect_to admin_doctors_url, notice: 'Doctor is successfully updated.' }
          format.json { render :show, status: :ok, location: @doctor }
        else
          format.html { render(partial: "shared/partials/errors", locals: { object: @doctor }, status: :bad_request) }
        end
      end
    end

    private

    def set_master_data
      @statuses = Doctor.statuses
      @doctor_degrees = DoctorDegree.latest
      @specialities = Speciality.latest
      @states = State.by_name

      @patients_in_panel = Doctor.patients_in_panels
      if current_user.has_role?(:admin) || current_user.has_role?(:data_entry)
        @patients_in_panel = @patients_in_panel.merge!({ '0-0' => 'Not available' })
      end

      @price_ranges = Doctor.price_ranges
      if current_user.has_role?(:admin) || current_user.has_role?(:data_entry)
        @price_ranges = @price_ranges.merge!({ '0-0' => 'Not available' })
      end

      @experiences = Doctor.experiences
      if current_user.has_role?(:admin) || current_user.has_role?(:data_entry)
        @experiences = @experiences.merge!({ '0-0' => 'Not available' })
      end
    end

    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    def doctor_params
      params.require(:doctor).permit(:title, :gender, :name, :slug, :practice_name, :style, :primary_speciality,
        :speciality_id, :min_experience, :max_experience, :language, :is_holistic_medicine, :holistic_option,
        :is_telehealth_service, :telehealth_option, :is_home_visit, :home_visit_option, :aditional_services,
        :min_price, :max_price, :min_patients, :max_patients, :access, :appointments, :consultation,
        :free_consultation_time, :about_clinic, :about_doctor, :email, :phone, :address_line_1, :address_suite,
        :state, :city, :zipcode, :fax, :website_url, :disciplinary_action_taken, :fmdd_score, :image, :status,
        :lat, :lng, :price_options, :patients_options, :prices, :patients_in_panel, :disciplinary_action_details,
        other_specialities: [], active_licenses: [], social_profiles: [[:social_link]], education: [[:year], [:name]],
        certifications: [[:year], [:name]], achievements: [[:year], [:name]])
    end
  end
end
