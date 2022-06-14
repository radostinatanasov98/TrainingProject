module Api
    class ExaminationsController < Api::ApplicationController
        def create
            unless self.valid_form_params?
                return render json: 'Unprocessable Entity.', status: 422
            end

            begin
                examination = Examination.create(user_id: form_params[:user_id], weight_kg: form_params[:weight_kg], 
                height_cm: form_params[:height_cm], anamnesis: form_params[:anamnesis],
                perscription: Perscription.create(description: form_params[:perscription][:description]))
        
                form_params[:perscription][:drugs].each do |d|
                    PerscriptionDrug.create(perscription_id: examination.perscription[:id], drug_id: d[:drug_id], usage_description: d[:usage_description])
                end
            rescue Exception => e
                render json: 'Unprocessable Entity.', status: 422
            else
                render json: 'OK.', status: 200
            end     
        end

        def get_by_id
            unless params[:id] && User.exists?(params[:id])
                return render json: 'Unprocessable Entity.', status: 422
            end
            
            user_examinations = Examination.where(user_id: params[:id])
            examinations = user_examinations.to_json(:include => { perscription: {:include => {perscription_drug: {:include => :drug}}}})
            render json: examinations
        end

        private

        def form_params
            params.permit(:user_id, :weight_kg, :height_cm, :anamnesis, perscription: [ :description, drugs: [ :drug_id, :usage_description ]])
        end

        def valid_form_params?
            unless int_parse(form_params[:user_id]).class == Integer
                puts 'user id'
                return false
            end

            unless float_parse(form_params[:weight_kg]).class == Float || int_parse(form_params[:weight_kg]).class == Integer
                puts 'weight kg'
                return false
            end

            unless float_parse(form_params[:height_cm]).class == Float || int_parse(form_params[:height_cm]).class == Integer
                puts 'height cm'
                return false
            end

            unless form_params[:anamnesis].class == String
                puts 'anamnesis'
                return false
            end

            unless form_params[:perscription][:description].class == String
                puts 'perscription description'
                return false
            end

            unless form_params[:perscription][:drugs] != nil
                puts 'perscription drugs'
                return false
            end

            form_params[:perscription][:drugs].each do |d|
                unless int_parse(d[:drug_id]).class == Integer
                    puts 'drug id'
                    return false
                end

                unless d[:usage_description].class == String
                    puts 'usage description'
                    return false
                end
            end

            true
        end

        def float_parse(str)
            true if Float(str) rescue false
        end

        def int_parse(str)
            true if Integer(str) rescue false
        end

    end
end

