class HomeController < ApplicationController
  def index
    render json: { message: 'Hello Rails' }
  end

  def search
    result = SearchService.new(search_params).run

    render json: result
  end

  private

  def search_params
    @search_params ||= params.permit(:city, :adults)
  end
end
