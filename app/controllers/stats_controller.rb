class StatsController < ApplicationController
  def index
    skip_authorization
    apply_filters
  end
end
