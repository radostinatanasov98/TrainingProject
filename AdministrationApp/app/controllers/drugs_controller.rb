class DrugsController < ApplicationController
    # Create
    def create
        @Drug = Drug.new
    end
    
    def new
        drug = Drug.new(name: form_params[:name], description: form_params[:description])

        return render json: 'Unprocessable Entity.', status: 422 unless drug.save
    
        redirect_to action: 'show', id: drug.id
    end

    # Read
    def all
        @Drugs = Drug.all
    end

    def show
        @Drug = Drug.find_by(id: params[:id])
    end

    # Update
    def update
        @Drug = Drug.find_by(id: params[:id])

        return render json: 'Bad Request.', status: 400 unless @Drug
    end

    def put
        drug = drug.find_by(id: form_params[:id])

        return render json: 'Unprocessable Entity.', status: 422 unless drug && drug.update(name: form_params[:name], description: form_params[:description])
    end

    # Delete
    def destroy
        drug = Drug.find_by(id: params[:id])

        return render json: "Bad Request", status: 400 unless drug

        drug.destroy
        redirect_to action: 'all'
    end

    private

    def form_params
        permitted_params = params.permit(:name, :description, :id)
    end
end