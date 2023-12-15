class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  
  def after_sign_in_path_for(resource)
      # Assuming 'resource' is a User object and has an 'id'
      # user_path(resource)
      root_path
  end

  # Custom method for array pagination
  def pagy_array(array, page: params[:page], items: 10)
    pagy_count = array.count
    pagy = Pagy.new(count: pagy_count, page: page, items: items)

    # Calculate the starting and ending item indexes
    from = (pagy.page - 1) * pagy.items
    to = from + pagy.items - 1

    # Paginate the array
    paginated_array = array[from..to]

    return pagy, paginated_array
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end