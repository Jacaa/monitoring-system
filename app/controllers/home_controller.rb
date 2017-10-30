class HomeController < ApplicationController
  def index
    @events = Event.all
  end

  def cookies_eu
  end
end
