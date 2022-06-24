module Api
  class ExaminationsController < Api::ApplicationController
    def create
      return render json: 'Unprocessable Entity.', status: 422 unless valid_form_params?

      begin
        examination = Examination.create(user_id: form_params[:user_id], weight_kg: form_params[:weight_kg],
                                         height_cm: form_params[:height_cm], anamnesis: form_params[:anamnesis],
                                         perscription: Perscription.create(description: form_params[:perscription][:description]))

        form_params[:perscription][:drugs].each do |d|
          PerscriptionDrug.create(perscription_id: examination.perscription[:id], drug_id: d[:drug_id],
                                  usage_description: d[:usage_description])
        end
      rescue Exception => e
        render json: 'Unprocessable Entity.', status: 422
      else
        render json: 'OK.', status: 200
      end
    end

    def get_by_id
      return render json: 'Unprocessable Entity.', status: 422 unless params[:id] && User.exists?(params[:id])

      user_examinations = Examination.where(user_id: params[:id]).order(created_at: :desc)
      examinations = user_examinations.to_json(include: { perscription: { include: { perscription_drug: { include: :drug } } } })
      render json: examinations
    end

    private

    def form_params
      params.permit(:user_id, :weight_kg, :height_cm, :anamnesis,
                    perscription: [:description, { drugs: %i[drug_id usage_description] }])
    end

    def valid_form_params?
      return false unless numeric?(form_params[:user_id])

      return false unless numeric?(form_params[:weight_kg])

      return false unless numeric?(form_params[:height_cm])

      return false unless form_params[:anamnesis].instance_of?(String)

      return false unless form_params[:perscription][:description].instance_of?(String)

      return false if form_params[:perscription][:drugs].nil?

      form_params[:perscription][:drugs].each do |d|
        return false unless numeric?(d[:drug_id])

        unless d[:usage_description].instance_of?(String)
          puts 'usage description'
          return false
        end
      end

      true
    end

    def numeric?(str)
      true if Float(str)
    rescue StandardError
      false
    end
  end
end
