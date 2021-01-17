class DataController < ApplicationController
  def doctor_names
    @doctors = Doctor.all.map do |doctor|
      {
        "name" => "#{doctor.name}",
      }
    end

    respond_to do |format|
      format.json do
        render json: @doctors.as_json
      end
    end
  end
end
