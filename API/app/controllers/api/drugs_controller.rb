module Api
    class DrugsController < Api::ApplicationController
        def get_all
            render json: Drug.all
        end
    end
end