class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :photo])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :photo])
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def coord(position)
    position -= 1
    [position.divmod(@game.grid_size).first, position.divmod(@game.grid_size).last]
  end

  def pos(coordinates)
    coordinates.last + (@game.grid_size * coordinates.first) + 1
  end

  def area(origin, desk)
    area = []
    y = 0
    desk.last.times do
      x = 0
      desk.first.times do
        area << [origin.first + y, origin.last + x]
        x += 1
      end
      y += 1
    end
    area
  end
end
