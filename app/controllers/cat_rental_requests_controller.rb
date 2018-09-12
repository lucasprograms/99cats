class CatRentalRequestsController < ApplicationController
  def index
    @cat_rental_requests = CatRentalRequest.all
  end

  def show
    @cat_rental_request = CatRentalRequest.find(params[:id])
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save!
      redirect_to cat_rental_request_url @cat_rental_request
    else
      render json: @cat_rental_request.errors.full_messages
    end
  end

  def new
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new
  end

  def edit
    @cat_rental_request = CatRentalRequest.find(params[:id])

    if @cat_rental_request.update!(cat_rental_request_params)
      redirect_to cat_rental_request_url @cat_rental_request
    else
      render json: @cat_rental_request.errors.full_messages
    end
  end

  def change_status(id, status)
    status = status.downcase.to_sym
    status_mapping = {
      approved: 'approve',
      denied: 'deny'
    }

    cat_rental_request = CatRentalRequest.find(id)
    cat_rental_request.public_send(status_mapping[status] + '!')
    redirect_to cat_url cat_rental_request.cat_id
  end

  def approve
    change_status(params[:id], 'APPROVED')
  end

  def deny
    change_status(params[:id], 'DENIED')
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end