class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save!
      redirect_to cat_url @cat
    else
      render json: @cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @cat = Cat.find(params[:id])
    @rental_requests_for_cat = @cat.cat_rental_requests
  end

  def new
    @cat = Cat.new
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update!(cat_params)
      redirect_to cat_url @cat
    else
      render json: @cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :description, :sex, :birth_date, :color)
  end
end
